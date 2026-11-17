# 01. Git · GitHub 흐름

## 핵심 개념
| 용어 | 뜻 |
|---|---|
| 커밋(commit) | 변경 사항의 스냅샷. 메시지로 "왜" 바꿨는지 남긴다 |
| 브랜치(branch) | 독립된 작업 줄기. `main`을 건드리지 않고 실험할 수 있다 |
| 원격(remote) | GitHub에 있는 저장소. 보통 이름이 `origin` |
| PR(Pull Request) | 브랜치의 변경을 `main`에 합쳐 달라는 요청. 리뷰와 CI가 여기서 돈다 |

## 이 프로젝트의 흐름 (GitHub Flow)
```bash
git switch main && git pull                 # 최신 main에서 시작
git switch -c phase-1/date-only             # 작업 브랜치 만들기
# ... 테스트 작성
git add CoffeeNoteTests/DateOnlyTests.swift
git commit -m "test(domain): D+N 테스트 추가 (TST-R1-01~05)"
# ... 구현
git commit -am "feat(domain): DateOnly와 D+N 계산"
git push -u origin phase-1/date-only        # 원격에 올리기
gh pr create --fill                         # PR 열기 → CI 실행
gh pr checks --watch                        # CI 결과 기다리기
gh pr merge --squash --delete-branch        # 리뷰 후 머지
```

## 커밋 메시지 규칙 (Conventional Commits)
`타입(범위): 요약` — 예: `feat(notes): 점수순 정렬 (TST-R4-01~04)`

- `feat` 기능 · `fix` 버그 · `test` 테스트 · `refactor` 동작 변화 없는 정리
- `docs` 문서 · `chore` 설정·도구 · `ci` CI 설정

## 자주 하는 실수와 복구
| 상황 | 명령 |
|---|---|
| 방금 커밋 메시지를 고치고 싶다(아직 push 전) | `git commit --amend` |
| 스테이징을 취소 | `git restore --staged <파일>` |
| 작업 중인 변경을 잠시 치워 두기 | `git stash` / `git stash pop` |
| main의 최신 변경을 내 브랜치에 반영 | `git switch main && git pull && git switch - && git rebase main` |

## 이 프로젝트에서 쓴 곳
- `.gitignore` — 생성물(`*.xcodeproj`), 비밀값(`GoogleService-Info.plist`)을 제외
- `.github/pull_request_template.md` — 작업 보고 형식

## 더 읽을거리
- [Pro Git (한국어)](https://git-scm.com/book/ko/v2)
- [GitHub Flow](https://docs.github.com/ko/get-started/using-github/github-flow)
- [Conventional Commits](https://www.conventionalcommits.org/ko/v1.0.0/)
