import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/config/di/core_providers.dart';
import 'package:luckify/core/constants/api_constants.dart';
import 'package:luckify/data/network/custom_interceptor.dart';
import 'package:luckify/data/network/network_client.dart';
import 'package:luckify/data/network/network_client_interface.dart';

final dioProvider = Provider<Dio>((ref) {
  final logger = ref.watch(loggerProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    LogInterceptor(requestBody: true, responseBody: true),
    CustomInterceptor(logger),
  ]);

  return dio;
});

final networkClientProvider = Provider<NetworkClientInterface>((ref) {
  return NetworkClient(ref.watch(dioProvider));
});