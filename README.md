# 🌟 Luckify - AI 기반 운세 앱
> 팀 정보: 개인 프로젝트
> 
> 
> **프로젝트 기간**: 2025.05 ~ 2025.05 (4주)
> 

## 🌟 서비스 소개
**Luckify**는 AI 기술을 활용하여 개인 맞춤형 운세를 제공하는 Flutter 앱입니다.

OpenAI API를 통해 오늘의 운세와 별자리 운세를 실시간으로 생성하고, Firebase 기반의 사용자 인증 및 데이터 관리를 통해 개인화된 운세 서비스를 제공합니다.

## 🌟 주요 기능
- **AI 맞춤 운세**: OpenAI GPT-4o-mini 기반 실시간 운세 생성
- **다양한 운세 타입**: 오늘의 운세, 별자리별 맞춤 운세 제공
- **운세 기록 관리**: Firebase Firestore 기반 개인별 운세 히스토리 저장
- **소셜 인증**: Google 소셜 로그인
- **실시간 채팅 UI**: 대화형 인터페이스로 자연스러운 운세 경험
- **계정 관리**: 로그아웃, 회원탈퇴

| Google 소셜 로그인 | 오늘의 운세/별자리 운세 선택 | 실시간 AI 운세 생성 |
|---|---|---|
| <img src="https://github.com/user-attachments/assets/17b61196-5c9b-4c19-93e2-a20efa94ec7b" width="280" height="520"> | <img src="https://github.com/user-attachments/assets/d39e05fd-2e0f-49bb-b82a-0c606995c188" width="280" height="520"> | <img src="https://github.com/user-attachments/assets/786a802a-c342-4f55-b214-fa28c4ed2cc1" width="280" height="520"> |

| 운세 히스토리 | 프로필 관리 | 히스토리 삭제 |
|---|---|---|
| <img src="https://github.com/user-attachments/assets/ce3b15cf-a59c-4782-8503-713997cd75e1" width="280" height="520"> | <img src="https://github.com/user-attachments/assets/804d917d-a65a-47d0-9b1c-74a5c9cf7a23" width="280" height="520"> | <img src="https://github.com/user-attachments/assets/e978bae1-ec88-42df-883d-6ad9f9bb1238" width="280" height="520"> |


## 🌟 개발 환경 및 라이브러리
| 분야 | 기술 | 버전 | 사용 목적 |
| --- | --- | --- | --- |
| **Frontend** | Flutter | 3.24.0 | 크로스 플랫폼 UI 프레임워크 |
|  | Dart | 3.7.2 | 애플리케이션 개발 언어 |
| **Backend** | Firebase Core | 3.13.0 | Firebase 초기화 및 설정 |
|  | Firebase Auth | 5.5.3 | Google 소셜 로그인 및 인증 |
|  | Cloud Firestore | 5.6.8 | 실시간 NoSQL 데이터베이스 |
|  | Google Sign In | 6.1.4 | Google 소셜 로그인 |
|  | OpenAI API | GPT-4o-mini | AI 기반 운세 생성 |
| **State Management** | Flutter Riverpod | 2.4.0 | 상태 관리 및 의존성 주입 |
| **Network** | Dio | 5.4.0 | HTTP 클라이언트 및 API 통신 |
| **UI Components** | Flutter Signin Button | 2.0.0 | Google 로그인 UI 컴포넌트 |
| **Utility** | Intl | 0.18.1 | 날짜 포맷팅 및 상대시간 표시 |
|  | UUID | 4.5.1 | 고유 식별자 생성 |
|  | Flutter Dotenv | 5.2.1 | 환경변수 관리 |
| **Testing** | Flutter Test | - | 단위 테스트 프레임워크 |
|  | Mockito | 5.4.4 | 의존성 모킹 |
|  | Build Runner | 2.4.8 | 코드 생성 도구 |

## 🌟 프레임워크 및 아키텍처
> Clean Architecture + MVVM
> 
- **Data Layer**: Repository 구현체, DTO, Firebase/OpenAI API 연동
- **Domain Layer**: 비즈니스 로직, Entity, UseCase, Repository 인터페이스
- **Presentation Layer**: UI 로직, ViewModel, State 관리

> Riverpod 기반 상태 관리
> 
- 전 계층에 걸친 통합 상태 관리 및 의존성 주입
- BaseViewModel/BaseState 패턴으로 공통 로직 추상화
- 메모리 효율적인 상태 관리로 최적화된 성능

> Firebase 통합 아키텍처
> 
- Firebase Auth를 통한 소셜 로그인 및 사용자 관리
- Firestore 실시간 데이터베이스로 운세 히스토리 관리
- 사용자별 데이터 격리 및 보안 강화

> 프로젝트 구조
> 

```
lib/
├── config/                # 의존성 주입 설정
│   └── di/                # Provider 설정
│
├── core/                  # 핵심 설정
│   ├── constants/         # 상수 정의
│   ├── exceptions/        # 예외 처리
│   ├── logger/            # 로그 시스템
│   ├── theme/             # 디자인 시스템
│   └── utils/             # 유틸리티
│
├── data/                  # 데이터 계층
│   ├── api/               # API 클라이언트
│   ├── dto/               # 데이터 전송 객체
│   ├── mapper/            # Entity-DTO 매핑
│   ├── network/           # 네트워크 클라이언트
│   └── repository/        # Repository 구현체
│
├── domain/                # 도메인 계층
│   ├── entity/            # 엔티티
│   ├── enum/              # 열거형
│   ├── repository/        # Repository 인터페이스
│   └── usecase/           # UseCase
│
└── presentation/          # 프레젠테이션 계층
    ├── screen/            # 화면 UI
    ├── viewmodel/         # 상태 관리
    ├── widget/            # 재사용 컴포넌트
    ├── formatters/        # 데이터 포매터
    └── util/              # 프레젠테이션 유틸리티
```

---

## 🌟 개발 과정에서 해결한 문제들
> Google 로그인 API 연동 이슈
> 

**문제**: Google 로그인 시도 시 `ApiException: 12500` 오류가 지속적으로 발생

**원인**: 개발 환경에서는 정상 작동하지만 특정 빌드에서만 실패하며, Firebase 프로젝트 설정과 앱 환경 간 불일치 발생

**해결**: Firebase 프로젝트 설정 재검토 및 정확한 SHA-1 인증서 지문 등록

```dart
// Firebase 콘솔 설정과 일치하는 SHA-1 지문 확인
$ ./gradlew signingReport

// Google Sign-In 구성 최적화
final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
if (googleUser == null) {
  throw AuthException(AuthError.cancelled);
}

final credential = firebase_auth.GoogleAuthProvider.credential(
  accessToken: googleAuth.accessToken,
  idToken: googleAuth.idToken,
);
```

**결과**: 개발 환경에서 안정적인 Google 소셜 로그인 구현 완료

---

> Firebase 재인증 보안 이슈
> 

**문제**: 회원 탈퇴 시 `requires-recent-login` 에러로 계정 삭제 실패

**원인**: Firebase 보안 정책상 민감한 작업 시 최근 로그인 증명 요구, 사용자가 재로그인해야 하는 번거로운 UX 문제

**해결**: Google Sign-In을 활용한 자동 재인증 플로우 설계 및 무중단 재인증 구현

```dart
Future<bool> _reauthenticateAndDeleteAccount(User user) async {
  try {
    // 자동 재인증 시도
    GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
    if (googleUser == null) {
      googleUser = await _googleSignIn.signIn();
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await user.reauthenticateWithCredential(credential);
    await user.delete();
    return true;
  } catch (e) {
    return false;
  }
}
```

**결과**: 사용자 개입 없이 원활한 계정 삭제 프로세스 완성

---

> 앱 생명주기 관리 문제
> 

**문제**: API 호출 중 화면 이탈 시 `Bad state: Tried to use ViewModel after dispose` 크래시 발생

**원인**: 비동기 작업 완료 전 ViewModel이 dispose되어 상태 업데이트 실패, 사용자 경험 저하 및 앱 안정성 문제

**해결**: 모든 상태 업데이트 메서드에 mounted 상태 체크 로직 추가 및 안전장치 구현

```dart
Future<void> _requestWithLoading(
  Future<FortuneMessageEntity> Function() action,
  String loadingContent,
) async {
  if (state.isRequestInProgress) return;

  try {
    final result = await runWithLoading(action);
    if (!mounted) return;  // 생명주기 체크

    removeMessage(loadingMessage.id);
    addMessage(result);
  } catch (e) {
    if (!mounted) return;  // dispose 후 상태 업데이트 방지
    _handleError(loadingMessage.id);
  }
}
```

**결과**: 화면 전환 시에도 안정적인 앱 동작 보장 및 크래시 완전 해결

---
