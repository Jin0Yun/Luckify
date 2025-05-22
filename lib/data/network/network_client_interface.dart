import 'package:luckify/data/network/base_api.dart';

abstract class NetworkClientInterface {
  Future<T> send<T>({
    required BaseApi api,
    required T Function(Map<String, dynamic>) fromJson,
  });
}