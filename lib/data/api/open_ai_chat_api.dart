import 'package:luckify/core/constants/api_constants.dart';
import 'package:luckify/data/dto/request_dto.dart';
import 'package:luckify/data/network/base_api.dart';
import 'package:luckify/data/network/http_method.dart';

class OpenAIChatApi implements BaseApi {
  final RequestDTO request;
  final String apiKey;

  OpenAIChatApi({required this.request, required this.apiKey});

  @override
  String get path => ApiConstants.chatCompletionsEndpoint;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  Map<String, dynamic>? get data => request.toJson();

  @override
  Map<String, dynamic>? get query => null;

  @override
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };
}