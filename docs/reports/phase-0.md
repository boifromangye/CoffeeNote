# Phase 0 보고 — 환경

브랜치: `chore/phase-0-setup` · 작성일: 2026-11-18

## 한 일
- Git 저장소 초기화(`main`), `.gitignore`(Xcode 생성물, 비밀값, Node, Emulator 로그)
- XcodeGen `project.yml`: iOS 17.0, iPhone 전용·세로, Swift 6, 개발 언어 ko, 앱 이름 한 곳 관리(D11)
- 빈 앱(`CoffeeNoteApp`, `RootView` 자리표시), `AppInfo.displayName`, String Catalog, Asset Catalog(AccentColor = design `accent` 토큰)
- 단위 테스트 타깃(Swift Testing) + 스모크 테스트 1개
- Firebase: `firebase.json`(Auth 9099 · Firestore 8080 · Functions 5001 · UI 4000), `.firebaserc`(`demo-coffeenote`), 모두 거부하는 자리표시 `firestore.rules`
- `functions/`: TypeScript, Functions 2nd gen 전역 리전 `asia-northeast3`, vitest + `@firebase/rules-unit-testing` 규칙 테스트 하네스, firebase-tools 버전 고정
- 스크립트: `bootstrap.sh`, `test-ios.sh`, `test-firebase.sh`, `emulators.sh`
- CI(GitHub Actions): iOS 빌드 + 단위 테스트 / Functions 빌드 + Emulator 규칙 테스트
- 문서: README, CLAUDE.md(작업 규칙 + 학습 모드), PR 템플릿, 학습 노트 00~04

## 통과한 확인
| 항목 | 결과 |
|---|---|
| iOS 단위 테스트 (iPhone 17 · iOS 26.5 시뮬레이터) | ✅ 1 passed |
| Functions 빌드 + 타입 검사 | ✅ |
| Emulator(Auth · Firestore · Functions) 기동 + 규칙 스모크 테스트 | ✅ 1 passed |
| CI | PR에서 확인 |

## 완료 조건 대비
- [x] 빈 앱이 iOS 26 시뮬레이터에서 실행
- [ ] 빈 앱이 **iOS 17** 시뮬레이터에서 실행 — 이 Mac에 iOS 17 런타임이 없음(남은 일 1)
- [x] Emulator 로컬 기동 / [ ] CI에서 기동 — 첫 PR에서 확인
- [ ] Firebase 실제 프로젝트·Blaze·예산 알림(spec T10) — 계정 작업이라 직접 해야 함(남은 일 2)

## 스펙과 다르게 한 점
- **Xcode 버전**: 계획은 Xcode 26 / iOS 26 SDK, 이 Mac에는 Xcode 27.2가 설치되어 있어 iOS 27 SDK로 빌드했다. D41의 목적(최신 SDK 빌드, iOS 17 최소 지원)은 유지된다.
- **firestore.rules**: 계획은 Phase 0 저장소 구조에 `firestore.rules`를 두는 것까지다. spec 7장 규칙 본문은 테스트 먼저 원칙(작업 규칙 3)에 따라 Phase 2에서 TST-S01~S11과 함께 넣는다. 지금은 모두 거부.

## 결정과 이유
- **XcodeGen** vs 일반 `.xcodeproj`: `.pbxproj` 충돌이 없고 설정을 텍스트로 리뷰할 수 있어 선택(저장소 주인 결정).
- **vitest** vs mocha/jest: TypeScript를 별도 설정 없이 실행, 빠름.
- **firebase-tools를 devDependency로 고정**: 전역 설치된 CLI(12.0.0)가 오래되어 최신 도구와 충돌했다. 로컬과 CI 버전을 맞추기 위해 고정.
- **demo- 프로젝트**: 실제 Firebase 프로젝트 없이 Emulator와 CI를 돌릴 수 있다.

## 남은 일 (저장소 주인)
1. iOS 17 시뮬레이터 런타임 설치: Xcode → Settings → Components에서 iOS 17.x 추가(약 7GB), 이후
   `DESTINATION='platform=iOS Simulator,name=iPhone 15,OS=17.5' scripts/test-ios.sh`
2. Firebase 콘솔: 프로젝트 생성 → Blaze 전환 + 예산 알림 → Firestore 리전 `asia-northeast3` → iOS 앱 등록 후 `GoogleService-Info.plist`를 `CoffeeNote/Resources/`에 두기(Git 제외됨) → `npx --prefix functions firebase use --add`
3. Xcode에서 서명 팀 지정(실기기 실행 시)

## 환경 메모
- 이 Mac은 Apple Silicon(M2 Max)인데 `/usr/local`의 Homebrew와 Node가 Intel(x86_64)판이라 Rosetta로 실행된다. Homebrew가 소스 빌드에 실패해 JDK 21은 Eclipse Temurin arm64 바이너리를 `~/Library/Java/JavaVirtualMachines`에 설치했다. 장기적으로는 `/opt/homebrew`에 arm64 Homebrew를 새로 설치하는 것을 권장한다.

## 남은 질문
없음

## 🧪 직접 해 보기
1. `Localizable.xcstrings`의 `root.placeholder.description` 값을 바꾸고 시뮬레이터에서 확인해 보기. 코드는 한 줄도 바꾸지 않아도 된다는 점을 확인.
2. `AppSmokeTests`에 일부러 실패하는 `#expect`를 추가해 Swift Testing이 어떤 메시지를 보여주는지 보고, 되돌리기.
3. `firestore.rules`의 `if false`를 `if true`로 바꾸고 `scripts/test-firebase.sh`를 실행해 규칙 테스트가 실패하는 것을 확인, 되돌리기. 보안 규칙 테스트가 왜 필요한지 체감해 보기.
