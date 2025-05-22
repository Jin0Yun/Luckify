import 'package:dio/dio.dart';
import 'package:luckify/core/logger/logger.dart';

class CustomInterceptor extends Interceptor {
  final AppLogger logger;

  CustomInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i('요청: ${options.method} ${options.path}', tag: 'NETWORK');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i('응답: ${response.statusCode}', tag: 'NETWORK');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('네트워크 오류', error: err, stackTrace: err.stackTrace, tag: 'NETWORK');
    super.onError(err, handler);
  }
}