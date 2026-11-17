import SwiftUI

// 📘 학습: @main은 앱의 진입점을 표시한다. SwiftUI 앱은 App 프로토콜을 따르는
// 구조체 하나에서 시작하고, body가 돌려주는 Scene(여기서는 WindowGroup)이 화면을 만든다.
@main
struct CoffeeNoteApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
