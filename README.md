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
| <img src="https://github.com/user-attachments/assets/2a6ec355-9bca-4fc2-8359-1578a4145948" width="280" height="520"> | <img src="https://github.com/user-attachments/assets/d39e05fd-2e0f-49bb-b82a-0c606995c188" width="280" height="520"> | <img src="https://github.com/user-attachments/assets/786a802a-c342-4f55-b214-fa28c4ed2cc1" width="280" height="520"> |

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

> **autoDispose를 활용한 메모리 최적화**

**문제**: 운세 채팅방을 나갔다가 다시 진입했을 때 이전 대화 내용이 그대로 유지되어 새로운 운세 조회가 불가능한 현상

**원인**: StateNotifierProvider.family 상태가 화면 생명주기와 독립적으로 앱 전체에서 유지되어 메모리에 계속 남아있음

**해결**: Riverpod의 autoDispose 수정자를 사용하여 상태 생명주기를 화면과 연결

```dart
// Before: 상태가 앱 전체에서 유지
final fortuneViewModelProvider = StateNotifierProvider.family<
  FortuneViewModel, FortuneState, FortuneEntity
>((ref, selectedFortune) => FortuneViewModel(...));

// After: 화면 종료 시 상태 자동 해제
final fortuneViewModelProvider = StateNotifierProvider.autoDispose.family<
  FortuneViewModel, FortuneState, FortuneEntity
>((ref, selectedFortune) => FortuneViewModel(...));
```

**결과**: 채팅방 재진입 시 항상 새로운 대화로 시작 가능, 메모리 효율성 향상

---

> **Google 로그인 SHA-1 인증서 불일치 해결**

**문제**: Google 로그인 시도 시 `ApiException: 12500` 오류가 지속적으로 발생

**원인**: Firebase 콘솔에 등록된 SHA-1 인증서 지문과 실제 앱의 SHA-1 값이 불일치하여 Google OAuth 인증 과정에서 앱 신원 확인 실패

**해결**: gradlew signingReport로 정확한 SHA-1 값 추출 후 Firebase 프로젝트 설정 업데이트

```bash
# 정확한 SHA-1 지문 추출
$ ./gradlew signingReport
```

```dart
// Google Sign-In 구성 최적화
final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
if (googleUser == null) {
  throw AuthException(AuthError.cancelled);
}

final credential = GoogleAuthProvider.credential(
  accessToken: googleAuth.accessToken,
  idToken: googleAuth.idToken,
);
```

**결과**: 개발 환경에서 안정적인 Google 소셜 로그인 구현 완료

---
