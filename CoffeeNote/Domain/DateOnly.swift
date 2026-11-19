import Foundation

/// 시각이 없는 달력 날짜(D19). Firestore에는 `"yyyy-MM-dd"` 문자열로 저장한다.
///
/// 📘 학습: `Date`는 "날짜"가 아니라 "한 순간(시각)"이다. 서울에서 11월 17일 00:30인 순간이
/// 호놀룰루에서는 11월 16일이다. 마신 날·로스팅일처럼 "그날"이 중요한 값을 `Date`로 들고 다니면
/// 기기 시간대에 따라 하루가 밀린다. 그래서 연·월·일만 가진 값 타입을 따로 만든다.
struct DateOnly: Hashable, Comparable, Sendable {
    let year: Int
    let month: Int
    let day: Int

    /// 존재하지 않는 날짜(예: 2월 30일)면 nil.
    init?(year: Int, month: Int, day: Int) {
        guard (1...9999).contains(year),
              (1...12).contains(month),
              (1...Self.daysInMonth(year: year, month: month)).contains(day)
        else { return nil }
        self.year = year
        self.month = month
        self.day = day
    }

    /// `"yyyy-MM-dd"` 형식만 받는다. 그 밖의 형식이나 없는 날짜면 nil.
    init?(_ string: String) {
        let parts = string.split(separator: "-", omittingEmptySubsequences: false)
        guard parts.count == 3,
              parts[0].count == 4, parts[1].count == 2, parts[2].count == 2,
              parts.allSatisfy({ $0.allSatisfy(\.isASCII) && $0.allSatisfy(\.isNumber) }),
              let year = Int(parts[0]), let month = Int(parts[1]), let day = Int(parts[2])
        else { return nil }
        self.init(year: year, month: month, day: day)
    }

    /// 한 순간(`Date`)이 주어진 시간대에서 며칠인지.
    /// "오늘"을 구할 때는 기기 시간대를 넘긴다: `DateOnly(.now, in: .current)`.
    init(_ date: Date, in timeZone: TimeZone) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        // 그레고리력 달력이 돌려준 값이므로 항상 유효한 날짜다.
        self.year = components.year!
        self.month = components.month!
        self.day = components.day!
    }

    /// `self - other`의 일수. `self`가 더 이르면 음수.
    func days(from other: DateOnly) -> Int {
        dayNumber - other.dayNumber
    }

    static func < (lhs: DateOnly, rhs: DateOnly) -> Bool {
        // 📘 학습: 튜플은 앞 요소부터 차례로 비교된다(연 → 월 → 일).
        (lhs.year, lhs.month, lhs.day) < (rhs.year, rhs.month, rhs.day)
    }
}

// MARK: - 일수 계산

private extension DateOnly {
    static func isLeapYear(_ year: Int) -> Bool {
        (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    }

    static func daysInMonth(year: Int, month: Int) -> Int {
        switch month {
        case 2: isLeapYear(year) ? 29 : 28
        case 4, 6, 9, 11: 30
        default: 31
        }
    }

    /// 1970-01-01을 0으로 하는 연속 일 번호.
    ///
    /// 📘 학습: `Calendar`로 두 날짜의 차이를 구하면 시간대·서머타임 전환일을 신경 써야 한다.
    /// 달력 날짜끼리의 차이는 정수 산술만으로 정확히 구할 수 있다(Howard Hinnant의 days_from_civil).
    /// 3월을 한 해의 시작으로 보면 윤일(2월 29일)이 해의 맨 끝에 와서 계산이 단순해진다.
    var dayNumber: Int {
        let y = month <= 2 ? year - 1 : year
        let era = y / 400                                   // year ≥ 1이므로 음수 처리 불필요
        let yearOfEra = y - era * 400                       // 0...399
        let monthFromMarch = (month + 9) % 12               // 3월 = 0 … 2월 = 11
        let dayOfYear = (153 * monthFromMarch + 2) / 5 + day - 1
        let dayOfEra = yearOfEra * 365 + yearOfEra / 4 - yearOfEra / 100 + dayOfYear
        return era * 146_097 + dayOfEra - 719_468
    }
}

// MARK: - 문자열 · Codable

extension DateOnly: CustomStringConvertible {
    /// `"yyyy-MM-dd"`. 문자열 정렬 순서가 날짜 순서와 같다(spec 7장).
    var description: String {
        String(format: "%04d-%02d-%02d", year, month, day)
    }
}

// 📘 학습: 기본 Codable 합성은 {"year":…,"month":…,"day":…} 객체를 만든다.
// singleValueContainer로 직접 구현하면 JSON·Firestore에 문자열 하나로 저장된다.
extension DateOnly: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let value = DateOnly(string) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Expected yyyy-MM-dd, got \(string)"
            )
        }
        self = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
