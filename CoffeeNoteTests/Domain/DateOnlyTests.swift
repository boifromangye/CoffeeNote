import Foundation
import Testing
@testable import CoffeeNote

// D19: DateOnly 타입, Firestore에는 "yyyy-MM-dd" 문자열.
// test-plan에 별도 ID는 없지만 R1·R3 테스트가 기대는 기반 동작이라 함께 고정해 둔다.
struct DateOnlyTests {
    @Test("\"yyyy-MM-dd\" 문자열로 만들고 같은 문자열로 돌아온다")
    func roundTripsThroughString() throws {
        let date = try #require(DateOnly("2026-11-16"))
        #expect(date.year == 2026 && date.month == 11 && date.day == 16)
        #expect(date.description == "2026-11-16")
    }

    @Test("한 자리 월·일은 0을 채워 저장한다", arguments: [
        (2026, 1, 5, "2026-01-05"),
        (999, 12, 31, "0999-12-31"),
    ])
    func zeroPads(year: Int, month: Int, day: Int, expected: String) throws {
        #expect(try #require(DateOnly(year: year, month: month, day: day)).description == expected)
    }

    @Test("형식이 틀리거나 없는 날짜는 만들 수 없다", arguments: [
        "2026/11/16", "2026-11-16T00:00:00Z", "26-11-16", "2026-1-16",
        "2026-13-01", "2026-02-30", "2026-00-10", "", "abcd-ef-gh",
    ])
    func rejectsInvalid(string: String) {
        #expect(DateOnly(string) == nil)
    }

    @Test("윤년 2월 29일")
    func leapDay() {
        #expect(DateOnly("2028-02-29") != nil)
        #expect(DateOnly("2026-02-29") == nil)
    }

    @Test("비교 순서는 날짜 순서와 같다")
    func comparable() throws {
        let a = try #require(DateOnly("2026-11-02"))
        let b = try #require(DateOnly("2026-11-16"))
        #expect(a < b)
        #expect(try #require(DateOnly("2026-12-31")) < (try #require(DateOnly("2027-01-01"))))
    }

    @Test("Codable: JSON에서 하나의 문자열 값으로 인코딩·디코딩된다")
    func codableAsSingleString() throws {
        struct Wrapper: Codable, Equatable { var drankOn: DateOnly }
        let original = Wrapper(drankOn: try #require(DateOnly("2026-11-16")))

        let data = try JSONEncoder().encode(original)
        #expect(String(decoding: data, as: UTF8.self) == #"{"drankOn":"2026-11-16"}"#)
        #expect(try JSONDecoder().decode(Wrapper.self, from: data) == original)
    }

    @Test("Codable: 형식이 틀린 문자열은 디코딩 오류")
    func decodingInvalidStringThrows() {
        let json = Data(#"{"drankOn":"2026/11/16"}"#.utf8)
        struct Wrapper: Codable { var drankOn: DateOnly }
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Wrapper.self, from: json)
        }
    }

    @Test("Date를 주어진 시간대의 달력 날짜로 바꾼다")
    func fromDateInTimeZone() throws {
        // 2026-11-16 15:30 UTC = 서울 2026-11-17 00:30, 호놀룰루 2026-11-16 05:30
        let instant = Date(timeIntervalSince1970: 1_794_843_000)
        #expect(DateOnly(instant, in: try #require(TimeZone(identifier: "Asia/Seoul"))).description == "2026-11-17")
        #expect(DateOnly(instant, in: try #require(TimeZone(identifier: "Pacific/Honolulu"))).description == "2026-11-16")
    }

    @Test("days(from:)은 두 날짜 사이의 일수, 음수도 가능")
    func daysBetween() throws {
        let a = try #require(DateOnly("2026-11-02"))
        let b = try #require(DateOnly("2026-11-16"))
        #expect(b.days(from: a) == 14)
        #expect(a.days(from: b) == -14)
        #expect(try #require(DateOnly("2029-01-01")).days(from: try #require(DateOnly("2028-01-01"))) == 366)
    }
}
