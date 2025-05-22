import 'package:luckify/data/network/http_method.dart';

abstract class BaseApi {
  String get path;
  HttpMethod get method;
  Map<String, dynamic>? get data;
  Map<String, dynamic>? get query;
  Map<String, String> get headers;
}