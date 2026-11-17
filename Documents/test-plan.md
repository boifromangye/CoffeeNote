# 커피콩책(가제) — Test Plan v1.1

짝 문서: specification.html v1.1 · design.html v1.1 · implementation-plan.md v1.1
작성일: 2026-11-17

## 0. 원칙

- 스펙의 규칙(R1~R11)과 화면 수용 기준마다 테스트 ID를 하나 이상 연결한다. 이 문서에 없는 동작은 "구현됨"으로 보지 않는다.
- AI 코딩 에이전트가 기능을 완료했다고 보고할 때는 **해당 테스트 ID의 통과 결과**를 함께 제출한다. 테스트를 수정해서 통과시키는 것은 금지한다. 테스트가 스펙과 다르다고 판단되면 구현을 멈추고 스펙 변경을 요청한다.
- 종류: `Unit`(Swift Testing, 순수 로직) · `VM`(ViewModel, Mock Repository) · `Emu`(Firebase Emulator: Firestore 규칙·Functions) · `UI`(XCUITest) · `Manual`(실기기 수동 확인, 체크리스트로 기록).
- 날짜가 들어가는 테스트는 "오늘"을 주입 가능한 `Clock`으로 고정한다(기준일 2026-11-16).

## 1. 도메인 규칙

### R1. D+N
| ID | 종류 | 조건 | 기대 결과 |
|---|---|---|---|
| TST-R1-01 | Unit | 로스팅 11-02, 마신 날 11-02 | D+0 |
| TST-R1-02 | Unit | 로스팅 11-02, 마신 날 11-16 | D+14 |
| TST-R1-03 | Unit | 로스팅일 없음 | 배지 없음(nil) |
| TST-R1-04 | Unit | 로스팅 2026-12-31, 마신 날 2027-01-01 | D+1 (연도 경계) |
| TST-R1-05 | Unit | 기기 시간대를 UTC−10, UTC+14로 바꿔도 | 01·02와 같은 결과 (`DateOnly`) |
| TST-R1-06 | VM | 원두 로스팅일을 수정 | 그 원두 모든 노트의 D+N이 다시 계산되어 표시 |

### R2. 이전 레시피 불러오기
| ID | 종류 | 조건 | 기대 결과 |
|---|---|---|---|
| TST-R2-01 | VM | 같은 원두 노트 3개(마신 날 서로 다름) | 마신 날이 가장 늦은 노트의 레시피 |
| TST-R2-02 | VM | 같은 날 노트 2개 | 작성 시각이 늦은 노트의 레시피 |
| TST-R2-03 | VM | 같은 원두 노트 없음 | 레시피 비어 있음, 배너 없음 |
| TST-R2-04 | VM | 불러온 레시피 | 오각형·태그·점수·후기는 복사되지 않음 |
| TST-R2-05 | VM | 레시피의 그라인더가 삭제됨 | 그라인더 칸만 비고 나머지는 채워짐 |
| TST-R2-06 | VM | 레시피를 직접 고친 뒤 원두 변경 | 덮어쓰기 확인 표시 |
| TST-R2-07 | VM | 편집 모드에서 원두 변경 | 불러오지 않음 |
| TST-R2-08 | VM | 배너의 "비우기" | 레시피 필드 전체 nil |

### R3. 검증 (NoteRule · BeanRule · GearRule)
| ID | 종류 | 조건 | 기대 결과 |
|---|---|---|---|
| TST-R3-01 | Unit | 원두 없음 | `beanRequired` |
| TST-R3-02 | Unit | 마신 날 < 로스팅일 | `drankBeforeRoast` |
| TST-R3-03 | Unit | 마신 날 > 오늘 | `drankInFuture` |
| TST-R3-04 | Unit | 점수 100.25 / −0.25 | `scoreOutOfRange` |
| TST-R3-05 | Unit | 점수 86.1 | `scoreStep` |
| TST-R3-06 | Unit | 프레그런스 태그 11개 | `tooManyTags` (컵 노트 10개는 별개로 허용) |
| TST-R3-07 | Unit | 물 온도 101 | `recipeOutOfRange` |
| TST-R3-08 | Unit | 후기 1001자 | `textTooLong` |
| TST-R3-09 | Unit | 원두 이름·로스터리 공백 | `nameRequired`, `roasteryRequired` |
| TST-R3-10 | Unit | 구성 6개 | `tooManyOrigins` |
| TST-R3-11 | Unit | 블렌드, 비율 모름 꺼짐, 비율 빈 구성 있음 | `ratioMissing` |
| TST-R3-12 | Unit | 블렌드 60/30 | `ratioSumNot100` |
| TST-R3-13 | Unit | 블렌드, 비율 모름 켜짐 | 통과, 모든 `ratioPercent` nil로 저장 |
| TST-R3-14 | Unit | 기존 노트 마신 날 11-05, 로스팅일을 11-06으로 변경 | `roastDateAfterExistingNote` |
| TST-R3-15 | Unit | 장비 이름 41자 | `nameTooLong` |

### R4. 내 점수
| ID | 종류 | 조건 | 기대 결과 |
|---|---|---|---|
| TST-R4-01 | Unit | 88.00 / 86.25 / null 섞인 목록, 점수순 | 88 → 86.25 → null |
| TST-R4-02 | Unit | 동점 2개, 마신 날 다름 | 마신 날 늦은 것이 먼저 |
| TST-R4-03 | Unit | 동점·같은 날 | 작성 시각 늦은 것이 먼저 |
| TST-R4-04 | Unit | null 여러 개 | 맨 아래, 최신순 |
| TST-R4-05 | Unit | 88 표시 | "88.00" |
| TST-R4-06 | Unit | 점수 없는 노트 인코딩 | `score` 키가 존재하고 값이 null |

### R5. 플레이버 태그
| ID | 종류 | 조건 | 기대 결과 |
|---|---|---|---|
| TST-R5-01 | Unit | "베리" 선택 후 "블루베리" 선택 | "베리" 해제 |
| TST-R5-02 | Unit | "블루베리" 선택 후 "과일" 선택 | "블루베리" 해제 |
| TST-R5-03 | Unit | 프레그런스 "자스민", 컵 노트 "자스민" | 둘 다 유지 |
| TST-R5-04 | Unit | 프레그런스 [블루베리], 컵 노트 [꿀] | tagIndex = {fruit, fruit.berry, fruit.berry.blueberry, sweet, sweet.honey} |
| TST-R5-05 | Unit | "fruit.berry"로 필터 | 블루베리·라즈베리·베리 노트 포함, "fruit"만 고른 노트 제외 |
| TST-R5-06 | Unit | deprecated 노드 | 선택 목록·검색 결과에 없음, 기존 노트 표시에는 있음 |
| TST-R5-07 | VM | 10개 선택 상태 | 선택 안 된 행 비활성, 안내 문구 표시 |

### R6. 삭제·확인·시트
| ID | 종류 | 조건 | 기대 결과 |
|---|---|---|---|
| TST-R6-01 | UI | 노트 삭제 스와이프 | 확인 메뉴(destructive) 후 삭제 |
| TST-R6-02 | VM | 노트 3개 있는 원두 삭제 | 메시지에 "노트 3개", 원두와 노트 모두 삭제 |
| TST-R6-03 | UI | D에 변경 있음, 아래로 스와이프 | 시트 유지, 확인 메뉴 표시 |
| TST-R6-04 | UI | D에 변경 있음, "취소" | 같은 확인 메뉴 |
| TST-R6-05 | UI | D 변경 없음, 스와이프 | 바로 닫힘 |
| TST-R6-06 | UI | D에서 레시피·태그 입력 → E → F 등록 → 복귀 | 입력값 유지, 새 원두 선택됨 |
| TST-R6-07 | UI | F·L 시트에도 06과 같은 조건 | 같은 동작 |

### R7. 계정과 전환
| ID | 종류 | 조건 | 기대 결과 |
|---|---|---|---|
| TST-R7-01 | Emu | 첫 실행 | 익명 사용자 생성, 사용자 문서 생성 |
| TST-R7-02 | Emu | 처음 쓰는 Apple 자격 증명 | link, uid 동일, 데이터 유지 |
| TST-R7-03 | Emu | 기록 있는 Apple 계정, 이 기기 노트 0 | 확인 없이 전환, 익명 계정 정리됨 |
| TST-R7-04 | Emu | 기록 있는 Apple 계정, 이 기기 노트 2 | 확인 메뉴, 취소 시 아무 변화 없음 |
| TST-R7-05 | Emu | 04에서 확인, sign in 실패 주입 | 익명 사용자·노트 2개 그대로, 티켓 정리 |
| TST-R7-06 | Emu | 04에서 확인, 성공 | Apple 계정 기록 표시, 익명 데이터·사용자 삭제 |
| TST-R7-07 | Emu | `cleanupAnonymous` 실패 주입 후 재실행 | 재시도로 정리 완료, 사용자 화면 영향 없음 |
| TST-R7-08 | Emu | 같은 ticketId로 cleanup 2회 | 두 번째도 성공(멱등) |
| TST-R7-09 | Emu | 익명 사용자가 `cleanupAnonymous` 호출 / 로그인 사용자가 `prepareAnonymousCleanup` 호출 | 둘 다 거부 |
| TST-R7-10 | VM | 로그아웃 | 확인 메뉴 후 새 익명 계정, 빈 목록 |

### R8. 보관 안내 카드
| ID | 종류 | 조건 | 기대 결과 |
|---|---|---|---|
| TST-R8-01 | VM | 익명, 첫 노트 저장 | 카드 표시 |
| TST-R8-02 | VM | 01 카드 닫음, 2~9번째 저장 | 미표시 |
| TST-R8-03 | VM | 익명, 10번째 저장 | 10개 문구로 표시 |
| TST-R8-04 | VM | Apple 연결 상태 | 어떤 경우에도 미표시 |
| TST-R8-05 | VM | 닫은 뒤 앱 재설치 없이 재실행 | 다시 나오지 않음(`backupPromptDismissed`) |

### R9. 저장·동기화 상태
| ID | 종류 | 조건 | 기대 결과 |
|---|---|---|---|
| TST-R9-01 | Emu | 네트워크 차단 후 저장 | `savedLocally`, 시트 닫힘, 문서 pending |
| TST-R9-02 | Emu | 01 후 네트워크 복구 | pending 해제(synced) |
| TST-R9-03 | Emu | 보안 규칙에 맞지 않는 데이터 강제 저장 | `failed`, alert, 편집 내용 유지 |
| TST-R9-04 | UI | pending 노트 존재 | B 배너 "동기화 대기 N개", 행 구름 아이콘 |
| TST-R9-05 | Unit | 저장 완료 문구 | 오프라인일 때 "기기에 저장됨"이며 "동기화됨" 아님 |

### R10. 데이터 삭제
| ID | 종류 | 조건 | 기대 결과 |
|---|---|---|---|
| TST-R10-01 | Emu | 원두 5·노트 20·장비 3인 사용자 `deleteAccount` | `users/{uid}` 및 beans·notes·gear 문서 0개, Auth 사용자 없음 |
| TST-R10-02 | Emu | 01을 중간 실패 주입 후 재호출 | 남은 문서까지 모두 삭제 |
| TST-R10-03 | Emu | 이미 삭제된 사용자 재호출 | 성공 응답 |
| TST-R10-04 | VM | 삭제 중 앱 종료 후 재실행(`pendingDeletion` 있음) | "계정 삭제를 마무리하고 있어요" 화면, 자동 재시도 |
| TST-R10-05 | Emu | 서명 검증 실패한 Apple 알림 | 400, 아무것도 삭제 안 함 |
| TST-R10-06 | Emu | `account-deleted` 알림 2회 | 데이터·사용자 삭제, 두 번째도 200 |
| TST-R10-07 | Emu | `email-disabled` 알림 | 기록만, 데이터 유지 |
| TST-R10-08 | Emu | 다른 사용자 데이터 | 01 실행 후에도 그대로 |

### R11. 태그 마이그레이션
| ID | 종류 | 조건 | 기대 결과 |
|---|---|---|---|
| TST-R11-01 | VM | 번들 version 2, 사용자 1, 노트 1,000개 중 변경 대상 120개 | 120개만 갱신, 배치 400 이하 |
| TST-R11-02 | VM | 오프라인 | 실행하지 않음, version 유지 |
| TST-R11-03 | VM | 두 번째 배치 실패 | `taxonomyVersion` 미갱신, 재실행 시 남은 것만 처리 |
| TST-R11-04 | VM | 모든 배치 성공 | `taxonomyVersion` = 2 |
| TST-R11-05 | VM | 변경 대상 0개 | 쓰기 없이 version만 갱신 |

## 2. 태그 데이터 (`flavor_taxonomy.json`)
| ID | 종류 | 검사 |
|---|---|---|
| TST-T01 | Unit | id 중복 없음 |
| TST-T02 | Unit | 모든 parentId가 존재, 최상위만 null |
| TST-T03 | Unit | 부모 level = 자식 level − 1, id 깊이 = level |
| TST-T04 | Unit | 부모와 group 같음 |
| TST-T05 | Unit | 부모·자식 nameKo 같지 않음, 같은 부모 아래 nameKo 중복 없음 |
| TST-T06 | Unit | JSON Schema(`flavor_taxonomy.schema.json`) 통과 — CI에서 실행 |
| TST-T07 | Unit | 출시 후: 이전 버전 JSON의 모든 id가 새 버전에 존재(삭제 대신 deprecated) |

## 3. Firestore 보안 규칙 (Emulator)
| ID | 검사 | 기대 |
|---|---|---|
| TST-S01 | 다른 uid 문서 읽기·쓰기 | 거부 |
| TST-S02 | 점수 200 / −1 | 거부 |
| TST-S03 | 점수 키 누락(null 아님) | 거부 |
| TST-S04 | 프로필 축 0 또는 6, 또는 3.5 | 거부 |
| TST-S05 | 컵 노트 태그 11개 | 거부 |
| TST-S06 | rebuy "sometimes" | 거부 |
| TST-S07 | 허용되지 않은 필드 추가 | 거부 |
| TST-S08 | drankOn "2026/11/16" | 거부 |
| TST-S09 | 장비 kind "kettle" | 거부 |
| TST-S10 | `cleanupTickets` 읽기·쓰기 | 거부 |
| TST-S11 | 정상 노트·원두·장비 | 허용 |

## 4. 화면 수용 기준 (UI · Manual)
각 화면 명세의 수용 기준 체크박스 순서대로 번호를 붙인다. 예: B 화면 세 번째 기준 = `TST-B-03`.

| 화면 | ID 범위 | 비고 |
|---|---|---|
| A | TST-A-01~04 | R7 테스트와 함께 |
| B | TST-B-01~06 | 정렬·필터·카드·검색 |
| C | TST-C-01~03 | |
| D | TST-D-01~10 | R6 시트 테스트 포함 |
| E | TST-E-01~02 | |
| F | TST-F-01~07 | 블렌드 비율 포함 |
| G | TST-G-01~05 | |
| H | TST-H-01~02 | |
| I | TST-I-01~02 | |
| J | TST-J-01~05 | 계정 삭제 포함 |
| K | TST-K-01~03 | |
| L | TST-L-01~02 | |

검색 범위(D20): `TST-B-SEARCH-01` 노트 2,000개 시드 후 가장 오래된 노트의 후기 단어로 검색 → 결과에 포함, 오프라인에서도 동일. `TST-B-PERF-01` 2,000개에서 첫 화면 1초 이내, 검색 반응 100ms 이내(Instruments).

## 5. HIG · 접근성 (Manual, iOS 17 실기기 + iOS 26 실기기)
| ID | 확인 항목 |
|---|---|
| TST-H01 | 가장 큰 접근성 글자 크기(AX5)에서 B·C·D·G·I 전 화면: 잘림·겹침 없음, B 행 세로 배치, I 기록 표가 카드로 전환 |
| TST-H02 | 원두 이름 60자·로스터리 40자: 목록 줄임, 상세 줄바꿈 |
| TST-H03 | 태그 10개 선택 상태의 G(AX5 포함): 선택 칩 영역이 목록을 가리지 않음 |
| TST-H04 | VoiceOver로 D 작성 완료까지 진행 가능(오각형 축, 점수 휠, 재구매, 태그) |
| TST-H05 | VoiceOver 오각형 라벨 "아로마 4, 산미 5, …" 및 차트 설명 |
| TST-H06 | 모든 상호작용 요소 44×44pt(Accessibility Inspector) |
| TST-H07 | 대비 증가 설정에서 고대비 색 적용 |
| TST-H08 | 동작 줄이기 설정에서 오각형 애니메이션 없음 |
| TST-H09 | iPhone SE(3세대) 크기에서 D·G 레이아웃 |
| TST-H10 | iOS 26: 탭 바·툴바·시트가 시스템 Liquid Glass로 표시되고 크림 배경과 충돌 없음, iOS 17: 기존 외관 |
| TST-H11 | 다크 모드 전 화면 |

## 6. 완료 기준 요약
- 단계별 완료 조건은 implementation-plan.md에 있다.
- 첫 TestFlight: 1~3장 전부 통과, 4장 해당 화면 통과, 5장 H01·H04·H06 통과.
- 심사 제출: 전부 통과 + 출시 체크리스트(spec 11장) 완료.
