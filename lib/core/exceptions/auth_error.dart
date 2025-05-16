enum AuthError {
  cancelled,
  invalidCredential,
  accountExists,
  networkError,
  tooManyRequests,
  userDisabled,
  operationNotAllowed,
  unknown,
}

extension AuthErrorMessage on AuthError {
  String get message {
    switch (this) {
      case AuthError.cancelled:
        return '로그인이 취소되었습니다.';
      case AuthError.invalidCredential:
        return '유효하지 않은 인증 정보입니다.';
      case AuthError.accountExists:
        return '이미 다른 방법으로 가입된 계정입니다.';
      case AuthError.networkError:
        return '네트워크 연결 상태를 확인해주세요.';
      case AuthError.tooManyRequests:
        return '너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요.';
      case AuthError.userDisabled:
        return '비활성화된 계정입니다.';
      case AuthError.operationNotAllowed:
        return '이 로그인 방식은 현재 지원되지 않습니다.';
      case AuthError.unknown:
        return '로그인 중 오류가 발생했습니다.';
    }
  }
}

class AuthException implements Exception {
  final AuthError type;
  final Exception? cause;

  AuthException(this.type, [this.cause]);

  @override
  String toString() => type.message + (cause != null ? ' (원인: $cause)' : '');
}