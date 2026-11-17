# 커피콩책(가제) — Implementation Plan v1.1

짝 문서: specification.html v1.1 · design.html v1.1 · test-plan.md v1.1
작성일: 2026-11-17

## 0. AI 코딩 에이전트 작업 규칙

1. **스펙이 기준이다.** 구현 중 스펙에 없는 결정이 필요하면 임의로 정하지 말고 작업을 멈추고 질문 목록을 남긴다. 예: 새 필드, 새 화면 상태, 문구, 에러 처리 방식.
2. **단계 순서를 지킨다.** 각 단계의 완료 조건(테스트 ID)을 통과하기 전에는 다음 단계로 넘어가지 않는다.
3. **테스트를 먼저 쓴다.** 단계마다 test-plan.md의 해당 테스트를 먼저 작성하고 실패를 확인한 뒤 구현한다.
4. **테스트를 고쳐서 통과시키지 않는다.** 테스트가 스펙과 다르다고 판단되면 보고한다.
5. **시스템 컴포넌트 우선.** 커스텀 UI는 오각형, 태그 칩, 축 입력, 시트 스와이프 래퍼만 허용한다(design 1장).
6. **문자열은 String Catalog에 넣는다.** 코드에 한국어 문자열을 직접 쓰지 않는다.
7. **비밀값은 저장소에 넣지 않는다.** `GoogleService-Info.plist`, Apple 키(.p8)는 `.gitignore`.
8. **작업 보고 형식:** 한 일 / 통과한 테스트 ID / 스펙과 다르게 한 점(없으면 "없음") / 남은 질문.

## 1. 단계

### Phase 0. 환경 (0.5일)
- Xcode 26, iOS 26 SDK, Deployment Target iOS 17.0, iPhone 전용·세로
- Firebase 프로젝트 생성, Blaze 전환과 예산 알림(spec T10), Firestore 리전 `asia-northeast3`
- Firebase Emulator Suite(Auth, Firestore, Functions) 로컬 실행 스크립트
- 저장소 구조: `App/`, `functions/`(TypeScript), `firestore.rules`, CI(빌드 + 단위 테스트 + 규칙 테스트)

**완료 조건:** 빈 앱이 iOS 17·26 시뮬레이터에서 실행, Emulator가 CI에서 기동.

### Phase 1. 도메인 (2일)
- `DateOnly`, `Bean`, `Origin`, `Note`, `Recipe`, `Gear`, `FlavorProfile`, `Rebuy`, `Serving`, `SaveState`, `SyncState`
- `NoteRule`, `BeanRule`, `GearRule`
- D+N 계산, 점수 정렬 비교자, 레시피 불러오기 선택 로직(순수 함수)
- `FlavorTaxonomy`(번들 JSON 로드·검증), 태그 선택 규칙, `tagIndex` 계산

**완료 조건:** TST-R1-01~05, R2-01~05(순수 로직 부분), R3 전체, R4 전체, R5-01~06, T01~T06 통과.

### Phase 2. 데이터 계층 (3일)
- Repository 프로토콜과 Mock
- Firestore Repository: beans·notes·gear 전체 구독(`includeMetadataChanges: true`), 저장 시 `tagIndex` 재계산, 점수 null 명시
- `firestore.rules`(spec 7장 그대로)
- `SyncState` 계산, 오프라인 영구 캐시 설정

**완료 조건:** TST-S01~S11, R9-01~03 통과.

### Phase 3. 서버 함수 (2일)
- `deleteAccount`, `prepareAnonymousCleanup`, `cleanupAnonymous`, `appleServerNotifications`
- `cleanupTickets` TTL 정책
- Apple 알림 JWS 검증(Apple 공개키), 멱등 처리

**완료 조건:** TST-R7-08~09, R10-01~03, R10-05~08 통과.

### Phase 4. 디자인 시스템 (2일)
- 색상 토큰(Asset Catalog, 다크·고대비), 타이포, 간격
- `PentagonChart`(S/M/L, 접근성 라벨·차트 설명, Reduce Motion)
- `FlavorTagChip`, `DPlusBadge`, `ScoreText`, 축 입력, `SyncBadge`
- `DiscardGuardedSheet`(UIKit `presentationControllerDidAttemptToDismiss` 브리지)

**완료 조건:** 컴포넌트 미리보기(라이트·다크·AX5), TST-H05·H07·H08 부분 확인.

### Phase 5. 화면 1차 — 조회 (3일)
- 탭 구조, B 노트 목록(정렬 메뉴, 검색, 태그 토큰 필터, 동기화 배너), C 노트 상세
- H 원두 목록, I 원두 상세(기록 표 ↔ 접근성 카드), J 설정(정보 섹션)

**완료 조건:** TST-B·C·H·I 수용 기준, R4(화면), R5-05(필터 화면), R9-04, B-SEARCH-01.

### Phase 6. 화면 2차 — 작성 (4일)
- D 노트 작성·편집(시트 + 내부 NavigationStack), R2 배너, 비율 계산
- E 원두 선택, F 원두 등록(구성 원두·비율 모름), G 태그 선택(선택·필터 모드), K 내 장비, L 장비 등록

**완료 조건:** TST-D·E·F·G·K·L 수용 기준, R2-06~08, R5-07, R6 전체.

### Phase 7. 계정 (3일)
- 익명 자동 로그인, A 시트, R7 전환 절차(티켓·Keychain·재시도), 로그아웃
- 계정 삭제(R10, `pendingDeletion` 재시도 화면), R8 보관 안내 카드
- Apple 토큰 철회(spec T2 확인 후)

**완료 조건:** TST-R7 전체, R8 전체, R10-04, TST-A·J 수용 기준.

### Phase 8. 마이그레이션·진단 (1일)
- R11 태그 마이그레이션
- Crashlytics(dSYM 업로드), 서버 거부·정리 실패 비치명 오류 기록

**완료 조건:** TST-R11 전체, 테스트 크래시가 콘솔에 기호화되어 표시.

### Phase 9. 검증·출시 준비 (3일)
- test-plan 5장 HIG·접근성 수동 점검(iOS 17·26 실기기), 성능(TST-B-PERF-01)
- 개인정보처리방침(GitHub Pages), 개인정보 라벨을 SDK Privacy Manifest와 대조, Sign in with Apple 서버 알림 URL 등록, App Check
- TestFlight 배포

**완료 조건:** test-plan 6장의 "첫 TestFlight" 기준 → 이후 "심사 제출" 기준.

## 2. 의존 관계

```
P0 ─ P1 ─┬─ P2 ─┬─ P5 ─ P6 ─ P7 ─ P8 ─ P9
         │      └─ P3 ────────┘
         └─ P4 ──────┘
```
- P3(서버 함수)는 P2와 병행 가능, P7 전에 끝나야 한다.
- P4(디자인 시스템)는 P1 이후 언제든 시작 가능, P5 전에 끝나야 한다.

## 3. 예상 일정
합계 약 23.5일(하루 8시간 기준). 주 5일이면 약 5주, 하루 4시간씩이면 약 10주.
