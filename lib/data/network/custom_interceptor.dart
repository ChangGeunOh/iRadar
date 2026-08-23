import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/common/utils/utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../common/const/network.dart';
import '../../domain/model/response/meta_data.dart' as response_data;
import '../../domain/model/response/response_data.dart';
import '../../domain/model/response/response_data.dart' as response_data;
import '../../domain/model/token_data.dart';
import '../../domain/repository/datastore_source.dart';

class CustomInterceptor extends Interceptor {
  final DataStoreSource dataStoreSource;
  final GoRouter router;

  CustomInterceptor({
    required this.router,
    required this.dataStoreSource,
  });

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final needsAccessToken = options.headers['access_token'] == true;

    if (needsAccessToken) {
      options.headers.remove('access_token');

      final tokenData = await dataStoreSource.getTokenData();
      final accessToken = tokenData?.accessToken;

      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) async {
    if (response.requestOptions.path.contains(kLoginPath)) {
      final tokenData = getTokenData(response);

      if (kDebugMode) {
        // ignore: avoid_print
        print('tokenData>$tokenData');
      }

      if (tokenData != null) {
        await dataStoreSource.setTokenData(tokenData);
      }
    }

    handler.next(response);
  }

  @override
  Future<void> onError(
      DioException originalError,
      ErrorInterceptorHandler handler,
      ) async {
    final isLoginRequest =
    originalError.requestOptions.path.contains(kLoginPath);
    final isUnauthorized = originalError.response?.statusCode == 401;

    // 로그인 요청 자체의 401은 토큰 갱신/라우팅 없이 공통 오류만 반환
    if (!isUnauthorized || isLoginRequest) {
      errorResolve(handler, originalError);
      return;
    }

    try {
      final tokenData = await dataStoreSource.getTokenData();
      final refreshToken = tokenData?.refreshToken;

      if (refreshToken == null || refreshToken.isEmpty) {
        await _logout();
        errorResolve(handler, originalError);
        return;
      }

      // 별도 Dio를 써서 refresh 요청이 이 interceptor를 다시 타지 않게 함
      final refreshDio = Dio()
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: false,
            responseBody: true,
            responseHeader: true,
            error: true,
            compact: true,
            maxWidth: 90,
          ),
        );

      final refreshResponse = await refreshDio.get(
        '$kNetworkBaseUrl$kTokenPath',
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      final newAccessToken = getTokenData(refreshResponse)?.accessToken;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        await _logout();
        errorResolve(handler, originalError);
        return;
      }

      await dataStoreSource.setTokenData(
        tokenData!.copyWith(accessToken: newAccessToken),
      );

      // 최초 실패 요청을 새 Access Token으로 한 번만 재시도
      final retryOptions = originalError.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryResponse = await refreshDio.fetch<dynamic>(retryOptions);

      handler.resolve(retryResponse);
    } on DioException catch (refreshError) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('token refresh failed: ${refreshError.message}');
      }

      await _logout();

      // refreshError가 아닌, 원래 실패한 요청을 기준으로 처리
      errorResolve(handler, originalError);
    } catch (e) {
      await _logout();
      errorResolve(handler, originalError);
    }
  }

  Future<void> _logout() async {
    await dataStoreSource.clearTokenData();
    router.go('/login');
  }

  void errorResolve(
      ErrorInterceptorHandler handler,
      DioException err,
      ) {
    try {
      ResponseData? responseData;

      if (err.response?.data != null) {
        responseData = ResponseData<dynamic>.fromJson(
          err.response!.data,
              (json) => json,
        );
      }

      final message =
          responseData?.meta.message ?? '잠시 후 다시 해 주세요.';

      final convertedResponse = ResponseData(
        meta: response_data.MetaData(
          code: err.response?.statusCode ?? 500,
          message: message,
        ),
        data: null,
      );

      handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          data: convertedResponse.getJson(),
          statusCode: 200,
        ),
      );
    } catch (_) {
      handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          data: response_data.ResponseData(
            meta: response_data.MetaData(
              code: 500,
              message: '잠시 후 다시 해 주세요.',
            ),
            data: null,
          ).getJson(),
          statusCode: 200,
        ),
      );
    }
  }

  TokenData? getTokenData(Response response) {
    final responseData = response_data.ResponseData<TokenData>.fromJson(
      response.data,
          (json) => TokenData.fromJson(json as Map<String, dynamic>),
    );

    return responseData.data;
  }
}