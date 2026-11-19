# 03. Firebase Emulator와 보안 규칙 테스트

## Emulator Suite
Firebase의 Auth·Firestore·Functions를 **내 컴퓨터에서 흉내 내는 서버**. 실제 프로젝트에 데이터를 쓰지 않고, 요금도 들지 않으며, 테스트마다 깨끗한 상태로 시작할 수 있다.

- `demo-`로 시작하는 프로젝트 ID(`demo-coffeenote`)는 실제 Firebase 프로젝트 없이 Emulator 전용으로 동작한다. `.firebaserc`에 지정했다.
- Firestore Emulator는 Java로 만들어져 있어 JDK가 필요하다.
- 포트: Auth 9099 · Firestore 8080 · Functions 5001 · UI 4000 (`firebase.json`)

## 보안 규칙(firestore.rules)이 중요한 이유
iOS 앱은 Firestore에 **직접** 접근한다. 서버 코드가 중간에 없으니, "남의 데이터를 못 읽게", "점수는 0~100만" 같은 검사를 보안 규칙이 서버 쪽에서 강제해야 한다. 앱 코드의 검증(NoteRule)은 사용자 경험용이고, 보안은 규칙이 담당한다.

## 규칙 테스트
`@firebase/rules-unit-testing`으로 "가짜 로그인 사용자"를 만들어 허용/거부를 검사한다.
```ts
const alice = env.authenticatedContext("alice").firestore();
await assertSucceeds(getDoc(doc(alice, "users/alice")));   // 내 문서: 허용
await assertFails(getDoc(doc(alice, "users/bob")));        // 남의 문서: 거부 (TST-S01)
```
Phase 0에서는 "모두 거부" 규칙과 그 확인 테스트 하나만 두었다. Phase 2에서 spec 7장의 규칙을 TST-S01~S11 테스트를 먼저 쓰고 옮겨 온다.

## 실행
```bash
scripts/test-firebase.sh   # Emulator를 띄우고 → 테스트 → 종료 (emulators:exec)
scripts/emulators.sh       # Emulator를 띄워 두고 UI에서 직접 데이터 확인
```
firebase-tools는 `functions/`의 devDependency로 고정해 두어 로컬과 CI가 같은 버전을 쓴다.

## 이 프로젝트에서 쓴 곳
- `firebase.json`, `.firebaserc`, `firestore.rules`, `functions/test/rules.smoke.test.ts`

## 더 읽을거리
- [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite)
- [보안 규칙 단위 테스트](https://firebase.google.com/docs/rules/unit-tests)
- [보안 규칙 언어](https://firebase.google.com/docs/firestore/security/rules-structure)
