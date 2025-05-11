enum NetworkError {
  invalidURL,
  badRequest,
  unauthorized,
  notFound,
  parsingFailed,
  serverError,
  unknown,
}

extension NetworkErrorMessage on NetworkError {
  String get message {
    switch (this) {
      case NetworkError.invalidURL:
        return '잘못된 URL입니다.';
      case NetworkError.badRequest:
        return '잘못된 요청입니다.';
      case NetworkError.unauthorized:
        return '인증되지 않은 요청입니다.';
      case NetworkError.notFound:
        return '요청한 리소스를 찾을 수 없습니다.';
      case NetworkError.parsingFailed:
        return '데이터를 처리하는 데 실패했습니다.';
      case NetworkError.serverError:
        return '서버 오류가 발생했습니다.';
      case NetworkError.unknown:
        return '알 수 없는 오류가 발생했습니다.';
    }
  }
}

class NetworkException implements Exception {
  final NetworkError type;

  NetworkException(this.type);

  @override
  String toString() => type.message;
}