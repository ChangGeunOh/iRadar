import 'package:dio/dio.dart';
import 'package:googlemap/common/const/network.dart';
import 'package:googlemap/domain/model/response/response_data.dart';
import 'package:googlemap/domain/model/token_data.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../domain/model/response/meta_data.dart';

class LocalNetwork {
  static Dio get dio {
    final dio = Dio();
    // dio.options.connectTimeout = const Duration(seconds: 5);
    // dio.options.receiveTimeout = const Duration(seconds: 5);
    // dio.options.sendTimeout = const Duration(seconds: 5);
    dio.interceptors.add(CustomInterceptor());
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
    return dio;
  }
}

class CustomInterceptor extends Interceptor {
  TokenData tokenData = TokenData();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // final customResponse = Response(
    //   requestOptions: err.requestOptions,
    //   statusCode: err.response?.statusCode,
    //   data: err.response?.data, // 사용자 정의 응답 내용
    // );
    //
    // // 에러를 정상 응답으로 처리
    // handler.resolve(customResponse);
    final responseData = ResponseData(
      meta: MetaData(
        code: err.response?.statusCode ?? 200,
        message: '네트워크 장애 입니다. 잠시 후 다시 해 주세요.',
        timeStamp: DateTime.now().millisecondsSinceEpoch,
      ),
      data: null,
    );
    handler.resolve(Response(
        requestOptions: err.requestOptions,
        data: responseData.getJson(),
        statusCode: 200));
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _setToken(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      _saveTokenData(response);
    }
    super.onResponse(response, handler);
  }

  void _setToken(RequestOptions options) {
    if (tokenData.accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${tokenData.accessToken}';
    }
  }

  void _saveTokenData(Response response) {
    if (response.requestOptions.path == (kPostTokenDataPath)) {
      try {
        final data = response.data as Map<String, dynamic>;
        final token = ResponseData<TokenData>(
          meta: MetaData.fromJson(data['meta'] as Map<String, dynamic>),
          data: TokenData.fromJson(data['data'] as Map<String, dynamic>),
        ).data;
        if (token != null) {
          tokenData = token;
        }
      } catch (e) {
        print('Error parsing response data: $e');
      }
    }
  }
}
