# 05. 값 타입으로 도메인 모델링 — DateOnly

Phase 1 · PR ① (TST-R1-01~05)

## 1. Date는 "날짜"가 아니다
`Date`는 **한 순간**(1970년 이후 몇 초)이다. 같은 순간이 서울에서는 11월 17일, 호놀룰루에서는 11월 16일이다. 마신 날·로스팅일을 `Date`로 저장하면 기기 시간대에 따라 D+N이 하루씩 달라질 수 있다. 그래서 연·월·일만 가진 `DateOnly`를 만들었다.

| | `Date` | `DateOnly` |
|---|---|---|
| 의미 | 한 순간 | 달력의 하루 |
| 시간대 영향 | 표시할 때마다 받음 | 없음 |
| Firestore 저장 | Timestamp | `"2026-11-16"` 문자열 |

`Date → DateOnly`로 바꾸는 순간에만 시간대가 필요하다: `DateOnly(.now, in: .current)`.

## 2. struct와 프로토콜 채택
```swift
struct DateOnly: Hashable, Comparable, Sendable { … }
```
- **struct(값 타입)**: 복사하면 독립된 값이 된다. 날짜처럼 "같은 값이면 같은 것"인 개념에 맞다.
- **Hashable**: `Set`, `Dictionary` 키로 쓸 수 있다. `Equatable`도 함께 따라온다. 프로퍼티가 모두 Hashable이면 컴파일러가 구현을 자동 생성한다.
- **Comparable**: `<`만 직접 구현하면 `>`, `<=`, `sorted()`, `max()`를 공짜로 쓸 수 있다.
- **Sendable**: 여러 스레드(액터)에 넘겨도 안전하다는 표시. Swift 6 엄격한 동시성 검사에 필요하다.

## 3. 실패 가능한 이니셜라이저 `init?`
`DateOnly("2026-02-30")`은 `nil`이다. 잘못된 값이 아예 **만들어질 수 없게** 하면, 이 타입을 쓰는 모든 코드가 "유효한 날짜인지"를 다시 검사할 필요가 없다.

## 4. 커스텀 Codable
기본 합성은 `{"year":2026,"month":11,"day":16}`을 만든다. `singleValueContainer`로 직접 구현해 `"2026-11-16"` 하나로 저장했다(D19). 형식이 틀린 문자열을 디코딩하면 `DecodingError`를 던진다.

## 5. 날짜 차이를 정수로 계산
`Calendar.dateComponents([.day], from:to:)`도 쓸 수 있지만 시간대·서머타임을 맞춰 줘야 한다. 달력 날짜는 "1970-01-01부터 며칠째"인 정수로 바꾸면 빼기 한 번으로 차이가 나온다(`dayNumber`, Howard Hinnant의 *days_from_civil*).

## 6. TDD 흐름 — 커밋 히스토리로 보기
```
git log --oneline phase-1/date-only
  feat(domain): DateOnly와 D+N 계산         ← Green
  test(domain): DateOnly와 D+N 테스트 추가   ← Red (컴파일 실패 확인)
```

## 7. Swift Testing 기능
- `@Test("TST-R1-01: …")` — 테스트 ID를 설명에 넣어 test-plan과 연결
- `@Test(arguments: [...])` — 같은 테스트를 여러 입력으로(잘못된 날짜 9개를 한 번에)
- `try #require(옵셔널)` — nil이면 그 자리에서 실패하고 멈춤
- `#expect(throws: DecodingError.self) { … }` — 오류가 나는지 검사
- `@Suite(.serialized)` — 전역 상태(시간대)를 바꾸는 테스트만 순서대로 실행

## 이 프로젝트에서 쓴 곳
- `CoffeeNote/Domain/DateOnly.swift`, `CoffeeNote/Domain/Rules/DPlus.swift`
- `CoffeeNoteTests/Domain/DateOnlyTests.swift`, `CoffeeNoteTests/Domain/DPlusTests.swift`

## 더 읽을거리
- [Choosing Between Structures and Classes](https://developer.apple.com/documentation/swift/choosing-between-structures-and-classes)
- [Encoding and Decoding Custom Types](https://developer.apple.com/documentation/foundation/encoding-and-decoding-custom-types)
- [Swift Testing — Parameterized testing](https://developer.apple.com/documentation/testing/parameterizedtesting)
- Howard Hinnant, [chrono-Compatible Low-Level Date Algorithms](https://howardhinnant.github.io/date_algorithms.html)

## 🧪 직접 해 보기
1. `DateOnly`에 `func adding(days: Int) -> DateOnly`를 추가하는 테스트를 **먼저** 써 보고(2026-12-31 + 1 = 2027-01-01), 구현해 보기. 힌트: `dayNumber`의 역함수(*civil_from_days*).
2. `DPlus.days`의 `roastDate.map { … }`을 `if let`/`guard let`으로 바꿔 써 보고, 어느 쪽이 읽기 편한지 비교하기.
3. `dayNumber`의 `- 719_468`을 지우고 테스트를 돌려 보기. 어떤 테스트가 왜 여전히 통과하는지 생각해 보기(차이만 쓰기 때문).
