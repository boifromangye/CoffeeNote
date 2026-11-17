import Testing
@testable import CoffeeNote

// 📘 학습: Swift Testing(@Test, #expect)은 XCTest의 후속 테스트 프레임워크다.
// 테스트 함수 이름 대신 @Test("설명")으로 의도를 적고, #expect가 실패하면 식의 값까지 보여준다.
// Phase 1부터는 test-plan.md의 테스트 ID(예: TST-R1-01)를 @Test 설명에 그대로 쓴다.
struct AppSmokeTests {
    @Test("Phase 0: 앱 표시 이름은 Info.plist 한 곳에서 온다 (D11)")
    func displayNameComesFromInfoPlist() {
        #expect(AppInfo.displayName.isEmpty == false)
    }
}
