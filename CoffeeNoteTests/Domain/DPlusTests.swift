import Foundation
import Testing
@testable import CoffeeNote

// test-plan.md R1. D+N
struct DPlusTests {
    // 📘 학습: try #require(옵셔널)은 nil이면 그 자리에서 테스트를 실패로 멈춘다.
    // 강제 언래핑(!)처럼 테스트 프로세스 전체가 크래시 나지 않아 원인을 찾기 쉽다.
    private func date(_ string: String) throws -> DateOnly {
        try #require(DateOnly(string))
    }

    @Test("TST-R1-01: 로스팅 11-02, 마신 날 11-02 → D+0")
    func sameDayIsDPlusZero() throws {
        #expect(DPlus.days(drankOn: try date("2026-11-02"), roastDate: try date("2026-11-02")) == 0)
    }

    @Test("TST-R1-02: 로스팅 11-02, 마신 날 11-16 → D+14")
    func fourteenDaysLater() throws {
        #expect(DPlus.days(drankOn: try date("2026-11-16"), roastDate: try date("2026-11-02")) == 14)
    }

    @Test("TST-R1-03: 로스팅일 없음 → nil(배지 없음)")
    func noRoastDateMeansNoBadge() throws {
        #expect(DPlus.days(drankOn: try date("2026-11-16"), roastDate: nil) == nil)
    }

    @Test("TST-R1-04: 로스팅 2026-12-31, 마신 날 2027-01-01 → D+1 (연도 경계)")
    func acrossYearBoundary() throws {
        #expect(DPlus.days(drankOn: try date("2027-01-01"), roastDate: try date("2026-12-31")) == 1)
    }
}

// 📘 학습: 기기 시간대(NSTimeZone.default)는 앱 전체가 공유하는 전역 상태다.
// 이 스위트만 .serialized로 순서대로 돌려, 바꾼 시간대를 테스트가 끝나면 되돌린다.
@Suite("TST-R1-05: 기기 시간대가 바뀌어도 D+N은 같다", .serialized)
struct DPlusTimeZoneTests {
    @Test(arguments: ["Pacific/Honolulu", "Pacific/Kiritimati"]) // UTC−10, UTC+14
    func resultIsIndependentOfDeviceTimeZone(identifier: String) throws {
        let original = NSTimeZone.default
        defer { NSTimeZone.default = original }
        NSTimeZone.default = try #require(TimeZone(identifier: identifier))

        let roast = try #require(DateOnly("2026-11-02"))
        #expect(DPlus.days(drankOn: roast, roastDate: roast) == 0)
        #expect(DPlus.days(drankOn: try #require(DateOnly("2026-11-16")), roastDate: roast) == 14)
    }
}
