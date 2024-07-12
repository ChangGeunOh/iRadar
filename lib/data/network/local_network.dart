import 'package:dio/dio.dart';
import 'package:googlemap/common/const/network.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'custom_interceptor.dart';

class LocalNetwork {
  final CustomInterceptor customInterceptor;

  LocalNetwork(this.customInterceptor,);

  Dio get dio {
    final dio = Dio();
    dio.interceptors.add(customInterceptor);
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
    dio.options.responseType = ResponseType.json;
    dio.options.baseUrl = kNetworkBaseUrl;

    return dio;
  }
}

// class CustomInterceptor extends Interceptor {
//   TokenData tokenData = TokenData();
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     // final customResponse = Response(
//     //   requestOptions: err.requestOptions,
//     //   statusCode: err.response?.statusCode,
//     //   data: err.response?.data, // 사용자 정의 응답 내용
//     // );
//     //
//     // // 에러를 정상 응답으로 처리
//     // handler.resolve(customResponse);
//     final responseData = ResponseData(
//       meta: MetaData(
//         code: err.response?.statusCode ?? 200,
//         message: '네트워크 장애 입니다. 잠시 후 다시 해 주세요.',
//         timeStamp: DateTime.now().millisecondsSinceEpoch,
//       ),
//       data: null,
//     );
//     handler.resolve(Response(
//       requestOptions: err.requestOptions,
//       data: responseData.getJson(),
//       statusCode: 200,
//     ));
//   }
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     _setToken(options);
//     super.onRequest(options, handler);
//   }
//
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     if (response.statusCode == 200) {
//       _saveTokenData(response);
//     }
//     super.onResponse(response, handler);
//   }
//
//   void _setToken(RequestOptions options) {
//     if (tokenData.accessToken != null) {
//       options.headers['Authorization'] = 'Bearer ${tokenData.accessToken}';
//     }
//   }
//
//   void _saveTokenData(Response response) {
//     if (response.requestOptions.path == (kPostTokenDataPath)) {
//       try {
//         final data = response.data as Map<String, dynamic>;
//         final token = ResponseData<TokenData>(
//           meta: MetaData.fromJson(data['meta'] as Map<String, dynamic>),
//           data: TokenData.fromJson(data['data'] as Map<String, dynamic>),
//         ).data;
//         if (token != null) {
//           tokenData = token;
//         }
//       } catch (e) {
//         print('Error parsing response data: $e');
//       }
//     }
//   }
// }
