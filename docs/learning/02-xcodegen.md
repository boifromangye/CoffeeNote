# 02. XcodeGen과 Xcode 프로젝트 구조

## 왜 XcodeGen인가
Xcode 프로젝트 파일(`project.pbxproj`)은 사람이 읽기 어렵고, 파일을 하나 추가해도 여러 곳이 바뀌어 Git 충돌이 잘 난다. XcodeGen은 **YAML 한 장(`project.yml`)으로 프로젝트를 설명**하고 `.xcodeproj`를 생성해 준다.

- `.xcodeproj`는 생성물이라 `.gitignore`에 넣었다.
- 설정을 바꿀 땐 Xcode 화면이 아니라 `project.yml`을 고치고 `xcodegen generate`.
- 새 Swift 파일은 `CoffeeNote/` 아래에 넣기만 하면 다음 생성 때 자동으로 포함된다.

> 실무에서는 일반 `.xcodeproj`를 쓰는 팀도 많다. Xcode의 Build Settings 화면에서 보이는 값이 `project.yml`의 `settings`와 1:1로 대응하니, Xcode에서 확인하며 비교해 보면 둘 다 익힐 수 있다.

## Xcode 용어
| 용어 | 뜻 | 이 프로젝트 |
|---|---|---|
| Target | 만들어지는 결과물 하나 | `CoffeeNote`(앱), `CoffeeNoteTests`(테스트 번들) |
| Scheme | 빌드·실행·테스트할 때 무엇을 어떻게 할지 묶음 | `CoffeeNote` |
| Build Setting | 컴파일 옵션 | `SWIFT_VERSION: 6.0`, `IPHONEOS_DEPLOYMENT_TARGET: 17.0` |
| Deployment Target | 지원하는 최소 iOS | 17.0 (spec 4장) |
| Bundle Identifier | 앱의 고유 ID | `io.github.boifromangye.CoffeeNote` |

## 생성된 Info.plist
`GENERATE_INFOPLIST_FILE: YES`면 Info.plist 파일 없이 `INFOPLIST_KEY_*` 설정으로 값을 넣는다. 앱 이름(D11)을 `INFOPLIST_KEY_CFBundleDisplayName` 한 곳에서 관리하는 이유다. 코드에서는 `AppInfo.displayName`으로 읽는다.

## String Catalog
`Localizable.xcstrings`는 Xcode 15부터 쓰는 문자열 파일이다. SwiftUI의 `Text("root.placeholder.title")`처럼 문자열 리터럴을 넘기면 `LocalizedStringKey`로 해석되어 카탈로그에서 값을 찾는다. 키를 코드에 쓰고, 한국어 값은 카탈로그에만 둔다(D22, 작업 규칙 6).

## Swift 6 언어 모드
`SWIFT_VERSION: 6.0`이면 **엄격한 동시성 검사**가 켜진다. 데이터 경쟁 가능성이 있는 코드는 컴파일 오류가 된다. 스펙의 `@MainActor` ViewModel 설계와 잘 맞는다. 처음엔 오류가 많아 보여도 대부분 "이 값을 어느 스레드(액터)에서 쓰는지" 명확히 하라는 뜻이다.

## 이 프로젝트에서 쓴 곳
- `project.yml`, `CoffeeNote/App/AppInfo.swift`, `CoffeeNote/Resources/Localizable.xcstrings`

## 더 읽을거리
- [XcodeGen ProjectSpec](https://github.com/yonaskolb/XcodeGen/blob/master/Docs/ProjectSpec.md)
- [Localizing and varying text with a string catalog](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog)
- [Swift Testing](https://developer.apple.com/documentation/testing)
- [Migrating to Swift 6](https://www.swift.org/migration/documentation/migrationguide/)
