enum FortuneError {
  invalidResponse,
  emptyChoices,
  apiError,
  parsingError,
  networkError,
  unknown,
}

extension FortuneErrorMessage on FortuneError {
  String get message {
    switch (this) {
      case FortuneError.invalidResponse:
        return '유효하지 않은 응답입니다.';
      case FortuneError.emptyChoices:
        return '운세 응답에 선택지가 없습니다.';
      case FortuneError.apiError:
        return 'API 오류가 발생했습니다.';
      case FortuneError.parsingError:
        return '응답 데이터 처리 중 오류가 발생했습니다.';
      case FortuneError.networkError:
        return '네트워크 연결을 확인해주세요.';
      case FortuneError.unknown:
        return '운세 조회 중 오류가 발생했습니다.';
    }
  }
}

class FortuneException implements Exception {
  final FortuneError type;
  final Exception? cause;

  FortuneException(this.type, [this.cause]);

  @override
  String toString() => type.message + (cause != null ? ' (원인: $cause)' : '');
}