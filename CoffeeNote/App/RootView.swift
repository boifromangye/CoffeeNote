import SwiftUI

/// Phase 0 자리표시 화면. Phase 5에서 탭 구조(노트 · 원두 · 설정)로 바뀐다.
struct RootView: View {
    var body: some View {
        // 📘 학습: Text("root.placeholder")의 문자열은 LocalizedStringKey로 해석되어
        // Localizable.xcstrings에서 한국어 값을 찾는다. 코드에 한국어를 직접 쓰지 않는 이유(D22).
        ContentUnavailableView(
            "root.placeholder.title",
            systemImage: "cup.and.saucer",
            description: Text("root.placeholder.description")
        )
    }
}

#Preview {
    RootView()
}
