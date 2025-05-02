import 'package:dio/dio.dart';
import 'package:luckify/data/logger/logger.dart';
import 'package:luckify/data/network/base_api.dart';
import 'package:luckify/data/network/http_method.dart';
import 'package:luckify/data/network/network_error.dart';

class NetworkClient {
  final Dio _dio;
  final AppLogger _logger;

  NetworkClient(this._dio, this._logger);

  Future<T> send<T>({
    required BaseApi api,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    _logger.i('API 요청 시작: ${api.path}', tag: 'NETWORK_CLIENT');

    try {
      final response = await _dio.request(
        api.path,
        data: api.data,
        queryParameters: api.query,
        options: Options(method: api.method.value),
      );

      _logger.d('API 응답 성공: ${api.path}', tag: 'NETWORK_CLIENT');

      if (response.data is Map<String, dynamic>) {
        return fromJson(response.data);
      } else {
        throw NetworkException(NetworkError.parsingFailed);
      }
    } catch (error, stackTrace) {
      _logger.e(
        'API 요청 실패: ${api.path}',
        error: error,
        stackTrace: stackTrace,
        tag: 'NETWORK_CLIENT',
      );

      if (error is DioException) {
        throw NetworkException(_mapError(error));
      }
      throw NetworkException(NetworkError.unknown);
    }
  }

  NetworkError _mapError(DioException e) {
    final statusCode = e.response?.statusCode;

    switch (statusCode) {
      case 400:
        return NetworkError.badRequest;
      case 401:
      case 403:
        return NetworkError.unauthorized;
      case 404:
        return NetworkError.notFound;
      case 500:
      case 502:
      case 503:
        return NetworkError.serverError;
      default:
        return NetworkError.unknown;
    }
  }
}