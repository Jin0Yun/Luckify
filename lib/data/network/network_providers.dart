import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:luckify/data/logger/console_logger.dart';
import 'package:luckify/data/logger/logger.dart';
import 'package:luckify/data/network/custom_interceptor.dart';
import 'package:luckify/data/network/network_client.dart';

final loggerProvider = Provider<AppLogger>((ref) {
  return ConsoleLogger();
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options = BaseOptions(
    baseUrl: 'https://api.openai.com/v1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  );

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  final logger = ref.watch(loggerProvider);
  dio.interceptors.add(CustomInterceptor(logger));

  return dio;
});

final networkClientProvider = Provider<NetworkClient>((ref) {
  final dio = ref.watch(dioProvider);
  final logger = ref.watch(loggerProvider);
  return NetworkClient(dio, logger);
});