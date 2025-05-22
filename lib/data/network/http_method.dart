enum HttpMethod { get, post, put, delete, patch }

extension HttpMethodExtension on HttpMethod {
  String get value => name.toUpperCase();
}