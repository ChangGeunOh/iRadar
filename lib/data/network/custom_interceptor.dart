import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:googlemap/common/utils/utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../common/const/network.dart';
import '../../domain/model/response/response_data.dart' as response_data;
import '../../domain/model/response/meta_data.dart' as response_data;
import '../../domain/model/response/response_data.dart';
import '../../domain/model/token_data.dart';
import '../../domain/repository/datastore_source.dart';

class CustomInterceptor extends Interceptor {
  final DataStoreSource dataStoreSource;
  final BuildContext context;

  CustomInterceptor({
    required this.context,
    required this.dataStoreSource,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isTokenPath = err.requestOptions.path.contains(kLoginPath);
    final isTokenError = err.response?.statusCode == 401;

    if (isTokenError && !isTokenPath) {
      try {
        final dio = Dio();
        dio.interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: false,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 90,
          ),
        );
        final tokenData = await dataStoreSource.getTokenData();
        final refreshToken = tokenData?.refreshToken;
        var response = await dio.get(
          '${Utils.baseUrl}$kTokenPath',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = getTokenData(response)?.accessToken;
        if (accessToken != null) {
          print('new accessToken>$accessToken');
          final options = err.requestOptions;
          options.headers.addAll({'authorization': 'Bearer $accessToken'});
          await dataStoreSource.setTokenData(
            tokenData!.copyWith(accessToken: accessToken),
          );
          response = await dio.fetch(options);
          handler.resolve(response);
          return;
        }
      } on DioException catch (err) {
        errorResolve(handler, err);
      }
      return;
    }
    errorResolve(handler, err);
  }

  void errorResolve(ErrorInterceptorHandler handler, DioException err) {
    try {
      ResponseData? responseData;
      if (err.response?.data != null) {
        responseData = ResponseData<dynamic>.fromJson(
          err.response!.data,
          (json) => json,
        );
      }

      final String message = err.response?.statusCode == 401
          ? '토큰이 만료 되었습니다.'
          : responseData?.meta.message ?? '잠시 후 다시 해 주세요.';

      responseData = ResponseData(
        meta: response_data.MetaData(
          code: err.response?.statusCode ?? 500,
          message: message,
        ),
        data: null,
      );

      handler.resolve(Response(
        requestOptions: err.requestOptions,
        data: responseData.getJson(),
        statusCode: 200,
      ));
    } catch (e) {
      handler.resolve(Response(
        requestOptions: err.requestOptions,
        data: response_data.ResponseData(
          meta: response_data.MetaData(
            code: 500,
            message: '잠시 후 다시 해 주세요.',
          ),
          data: null,
        ).getJson(),
      ));
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final hasAccessToken = options.headers['access_token'] ?? false;
    if (hasAccessToken) {
      options.headers.remove('access_token');
      final tokenData = await dataStoreSource.getTokenData();
      final accessToken = tokenData?.accessToken;
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    super.onResponse(response, handler);
    if (response.requestOptions.path.contains(kLoginPath)) {
      final tokenData = getTokenData(response);
      print('tokenData>$tokenData');
      if (tokenData != null) {
        await dataStoreSource.setTokenData(tokenData);
      }
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
