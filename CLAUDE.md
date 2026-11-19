# CLAUDE.md — 커피콩책(CoffeeNote) 작업 규칙

이 저장소는 **Spec-Driven Development**로 진행한다. 저장소 주인은 iOS 개발을 공부하면서 만들고 있으므로, 코드를 만드는 것과 같은 무게로 **이해를 돕는 것**이 목표다.

## 1. 기준 문서 (항상 먼저 읽기)

| 문서 | 역할 |
|---|---|
| `Documents/specification.html` | 무엇을 만드는가 — 결정 로그(D*), 규칙(R1~R11), 데이터, 화면 A–L |
| `Documents/design.html` | 어떻게 보이는가 — 토큰, 컴포넌트, 화면 목업 |
| `Documents/implementation-plan.md` | 어떤 순서로 — Phase 0~9와 완료 조건 |
| `Documents/test-plan.md` | 무엇이 "완료"인가 — 테스트 ID(TST-*) |
| `Documents/flavor_taxonomy*.json` | 태그 데이터와 스키마 |

## 2. 에이전트 작업 규칙 (implementation-plan 0장)

1. **스펙이 기준이다.** 스펙에 없는 결정(새 필드, 화면 상태, 문구, 에러 처리)이 필요하면 임의로 정하지 말고 멈추고 질문 목록을 남긴다.
2. **단계 순서를 지킨다.** 현재 Phase의 완료 조건(테스트 ID)을 통과하기 전에 다음 Phase로 넘어가지 않는다.
3. **테스트를 먼저 쓴다.** test-plan의 해당 테스트를 먼저 작성 → 실패 확인 → 구현.
4. **테스트를 고쳐서 통과시키지 않는다.** 테스트가 스펙과 다르면 보고한다.
5. **시스템 컴포넌트 우선.** 커스텀 UI는 오각형, 태그 칩, 축 입력, 시트 스와이프 래퍼만.
6. **문자열은 String Catalog(`Localizable.xcstrings`)에.** 코드에 한국어 문자열을 직접 쓰지 않는다(주석·테스트 설명은 예외).
7. **비밀값은 저장소에 넣지 않는다.** `GoogleService-Info.plist`, `.p8` 등은 `.gitignore`.
8. **작업 보고 형식:** 한 일 / 통과한 테스트 ID / 스펙과 다르게 한 점(없으면 "없음") / 남은 질문. PR 템플릿과 `docs/reports/phase-N.md`에 같은 형식으로 남긴다.

## 3. Git · GitHub 흐름

- `main`은 항상 빌드·테스트가 통과하는 상태. 직접 커밋하지 않는다.
- 작업 단위마다 브랜치: `phase-N/<짧은-설명>` (예: `phase-1/date-only`), 설정 작업은 `chore/...`.
- 커밋 메시지: [Conventional Commits](https://www.conventionalcommits.org/) + 한국어 본문. 예: `feat(domain): DateOnly와 D+N 계산 (TST-R1-01~05)`
  - 타입: `feat` · `fix` · `test` · `refactor` · `docs` · `chore` · `ci`
  - 테스트 먼저 쓰는 흐름이 히스토리에 보이도록 `test:` 커밋 → `feat:` 커밋 순서를 권장한다.
- PR을 열면 CI(iOS 테스트 + Emulator 테스트)가 통과해야 머지한다. 머지는 저장소 주인이 직접 한다.
- 각 Phase는 GitHub 이슈 하나와 대응한다(라벨 `phase`).

## 4. 학습 모드 (저장소 주인이 iOS를 공부 중)

에이전트는 작업할 때 다음을 지킨다.

- **처음 나오는 개념은 짧게 설명한다.** 코드에는 `// 📘 학습:` 주석으로 "왜 이렇게 하는지"를 1~3줄로 남긴다. 같은 개념을 반복 설명하지 않는다(이미 `docs/learning/`에 있으면 그 문서를 가리킨다).
- **Phase마다 학습 노트를 쌓는다.** `docs/learning/NN-주제.md`에 개념, 이 프로젝트에서 쓴 위치(파일 경로), 공식 문서 링크, 더 읽을거리를 정리한다. 목록은 `docs/learning/README.md`.
- **직접 해 볼 과제를 남긴다.** 각 Phase 보고서 끝에 "🧪 직접 해 보기" 1~3개(작은 변경, 테스트 추가, 디버깅 실습)를 적는다. 과제는 스펙을 벗어나지 않는 범위에서 고른다.
- **결정의 이유를 남긴다.** 여러 방법 중 하나를 골랐다면 대안과 고른 이유를 보고서에 한두 줄로 적는다.
- **설명은 한국어, 코드 식별자는 영어.**

## 5. 자주 쓰는 명령

```bash
scripts/bootstrap.sh       # 처음 한 번: Xcode 프로젝트 생성 + npm ci
scripts/test-ios.sh        # iOS 단위 테스트
scripts/test-firebase.sh   # Functions 빌드 + Emulator 규칙 테스트
scripts/emulators.sh       # Emulator UI(http://localhost:4000)로 직접 확인
```

`.xcodeproj`는 `project.yml`에서 생성되므로 Xcode에서 파일·설정을 바꾸지 말고 `project.yml`을 고친 뒤 `xcodegen generate`를 다시 실행한다. 새 Swift 파일은 폴더에 넣기만 하면 생성 시 자동으로 포함된다.
