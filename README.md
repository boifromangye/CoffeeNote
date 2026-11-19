# 커피콩책 (CoffeeNote, 가제)

커피를 마신 뒤 원두 정보, 추출 레시피, 오각형 맛 프로필, 플레이버 태그, 후기와 점수를 남기는 iOS 테이스팅 노트 앱.

> Spec-Driven Development로 진행하는 iOS 학습 프로젝트입니다. 모든 기능은 [스펙](Documents/specification.html)과 [테스트 계획](Documents/test-plan.md)의 테스트 ID로 추적합니다.

## 기술 스택

- SwiftUI + MVVM(`@Observable`), iOS 17.0+, iPhone 전용
- Firebase: Auth(익명 → Sign in with Apple), Cloud Firestore(오프라인 캐시), Cloud Functions(2nd gen, TypeScript)
- 테스트: Swift Testing · Firebase Emulator Suite
- 프로젝트 생성: [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## 시작하기

필요한 도구: Xcode 26 이상, XcodeGen, Node.js 22+, JDK 21(Firestore Emulator용)

```bash
scripts/bootstrap.sh        # Xcode 프로젝트 생성 + Functions 의존성 설치
open CoffeeNote.xcodeproj
```

| 명령 | 설명 |
|---|---|
| `scripts/test-ios.sh` | iOS 단위 테스트 |
| `scripts/test-firebase.sh` | Functions 빌드 + Emulator에서 보안 규칙 테스트 |
| `scripts/emulators.sh` | Emulator 실행 (UI: http://localhost:4000) |

Firebase 실제 프로젝트 없이도 `demo-coffeenote` 데모 프로젝트로 Emulator가 동작합니다. `GoogleService-Info.plist`는 저장소에 포함하지 않습니다.

## 저장소 구조

```
CoffeeNote/          iOS 앱 소스 (App, Domain, Data, Features, DesignSystem, Resources)
CoffeeNoteTests/     단위 테스트 (Swift Testing)
functions/           Cloud Functions(TypeScript) + Emulator 테스트
firestore.rules      Firestore 보안 규칙
Documents/           스펙 · 디자인 · 구현 계획 · 테스트 계획
docs/learning/       학습 노트
docs/reports/        Phase별 작업 보고
project.yml          XcodeGen 프로젝트 정의
```

## 진행 상황

| Phase | 내용 | 상태 |
|---|---|---|
| 0 | 환경 | 진행 중 ([보고서](docs/reports/phase-0.md)) |
| 1 | 도메인 | |
| 2 | 데이터 계층 | |
| 3 | 서버 함수 | |
| 4 | 디자인 시스템 | |
| 5 | 화면 1차 — 조회 | |
| 6 | 화면 2차 — 작성 | |
| 7 | 계정 | |
| 8 | 마이그레이션·진단 | |
| 9 | 검증·출시 준비 | |

자세한 단계와 완료 조건은 [implementation-plan.md](Documents/implementation-plan.md)를 참고하세요.
