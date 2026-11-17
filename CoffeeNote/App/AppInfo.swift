import Foundation

/// 앱 이름 등 앱 정보의 단일 참조 지점(D11).
/// 이름은 project.yml의 INFOPLIST_KEY_CFBundleDisplayName 한 곳에서만 바꾼다.
enum AppInfo {
    static var displayName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? ""
    }
}
