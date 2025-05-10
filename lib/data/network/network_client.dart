import 'package:dio/dio.dart';
import 'package:luckify/core/logger/logger.dart';
import 'package:luckify/core/exceptions/network_error.dart';
import 'package:luckify/data/network/base_api.dart';
import 'package:luckify/data/network/http_method.dart';
import 'package:luckify/data/network/network_client_interface.dart';

class NetworkClient implements NetworkClientInterface {
  final Dio _dio;
  final AppLogger _logger;

  NetworkClient(this._dio, this._logger);

  @override
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
        options: Options(method: api.method.value, headers: api.headers),
      );

      _logger.d('API 응답 성공: ${api.path}', tag: 'NETWORK_CLIENT');

      if (response.data is Map<String, dynamic>) {
        return fromJson(response.data);
      } else {
        throw NetworkException(NetworkError.parsingFailed);
      }
    } on DioException catch (error, stackTrace) {
      _logger.e(
        'API 요청 실패: ${api.path}',
        error: error,
        stackTrace: stackTrace,
        tag: 'NETWORK_CLIENT',
      );
      throw NetworkException(_mapError(error));
    } catch (error, stackTrace) {
      _logger.e(
        'API 요청 실패: ${api.path}',
        error: error,
        stackTrace: stackTrace,
        tag: 'NETWORK_CLIENT',
      );
      throw NetworkException(NetworkError.unknown);
    }
  }

  NetworkError _mapError(DioException e) {
    final statusCode = e.response?.statusCode;

    return switch (statusCode) {
      400 => NetworkError.badRequest,
      401 || 403 => NetworkError.unauthorized,
      404 => NetworkError.notFound,
      500 || 502 || 503 => NetworkError.serverError,
      _ => NetworkError.unknown,
    };
  }
}