# SunKit

SunKit is the shared foundation for Sun's Apple-platform apps. It ships two libraries from one
package:

| Library | Depends on | Purpose |
|---|---|---|
| `SunCore` | Apple SDK only | Networking, persistence, settings, formatters and small Foundation helpers |
| `SunUserInterface` | `SunCore`, SwiftUI | Routing and presentation, styling tokens, popups, localization helpers |

Swift 6 language mode. Platforms: iOS 17, macOS 14, visionOS 1 or later.

## What is inside

### SunCore

| Area | Main types | What it gives you |
|---|---|---|
| Networking | `APIRequest`, `APIClient`, `APIRequestSending`, `RequestBuilder`, `RequestBody`, `RequestSender`, `RequestSending`, `HTTPResponse`, `HTTPError`, `HTTPMethod`, `ResponseDecoder`, `ResponseDecoding`, `EmptyResponse`, `NetworkError` | Requests declare path segments and a typed response; only `RequestBuilder` assembles URLs. The transport returns HTTP metadata, `APIClient` validates status codes and decodes. Cancellation, transport and codec errors are preserved, and writes are never retried automatically. |
| Persistence | `ModelStorage` | A schema-independent SwiftData wrapper: one `ModelContext`, explicit `save()` and `rollback()`. |
| Settings | `Settings`, `SettingsKey`, `SettingStorage` | Observable, typed `UserDefaults` settings scoped by namespace and user ID. Reads and writes throw, so corrupt or unencodable values stay visible. |
| Formatters | `CurrencyFormatter`, `DecimalFormatter`, `PercentFormatter` | Locale-aware number formatting; each call builds its own formatter, so nothing mutable is shared. |
| Utilities | `FileManagement`, `DoubleOrString`, `AnyOptional`, extensions on `Array`, `Double`, `Encodable`, `CaseIterable` | Small helpers that several apps kept rewriting. |

### SunUserInterface

| Area | Main types | What it gives you |
|---|---|---|
| Routing | `FeatureDestination`, `FeatureDestinationView`, `FeatureRouting`, `FeatureHost`, `Navigator`, `NavigationState`, `FeaturePresentation`, `Routing`, `AppRouting`, `AppRouter`, `LinkRouting` | Destination → Router → DestinationView → Host. A feature host only supplies its router and root view; `Navigator` provides the `NavigationStack` bound to the router's path, destination registration and sheet / full-screen / popup presentation. `AppRouter` maps URLs to feature destinations. |
| Presentation | `PresentingStyle`, `View.present(...)` | One API for push, sheet, full-screen cover and popup, driven by state. |
| Dimensions | `DimensionStyling`, `DimensionToken`, `DimensionTokens`, `DimensionStyle`, `EnvironmentValues.dimensions` | Generic spacing, radius, border and progress sizes, read from a JSON file in the app bundle and injected through the environment. Apps add their own tokens (see below). |
| Fonts | `FontStyling`, `FontToken`, `FontStyles`, `FontStyleTokens`, `FontStyle`, `FontStyleModifier` | Named text styles with Dynamic Type and line height, loaded from a JSON file. |
| Images and colors | `ImageStyling`, `ImageTokens`, `ColorStyling`, `Image(style:)`, `Label(_:imageStyle:)` | Views use named styles instead of SF Symbol or asset name strings. |
| Text and controls | `TextStyle`, `TextModifier`, `ForegroundColorStyle`, `BackgroundStyle`, `PrimaryButtonStyle`, `ButtonDimension`, `PlaceholderStyling`, `AccessibilityIdentifying` | Reusable modifiers and styles built on the tokens above. |
| Popups | `Popup`, `PopupManager`, `PopupStyling`, `PlainPopupStyle`, `ClosablePopupStyle`, `View.setPopupRoot()` | In-app popups with replaceable styles; dismissing an old popup never clears a newer one. |
| Localization | `LocalizationTable`, `NamedLocalizationTable`, `LocalizedString`, `LocalizedText` | Lazy lookups across bundles and tables, with plural support and fallback. |

## When to use it

- **Link only `SunCore`** for targets without SwiftUI screens, such as a command-line tool or a
  networking-only module.
- **Use `SunUserInterface`** whenever a feature has its own navigation: give it a destination enum, a
  router and a `FeatureHost`, instead of hand-writing `NavigationStack` and
  `navigationDestination` in the feature.

What stays in each app, never in SunKit:

- token values (`DimensionTokens.json`, `FontTokens.json`, `ImageTokens.json`), named styles,
  colors and assets;
- server configuration, endpoints, DTOs, models and their validation;
- String Catalogs and localization keys;
- layout helpers written for a single app.

SunKit APIs must stay usable without importing any app. Only add code here when it serves the
package's own features or at least two apps need it.

## Adding SunKit to a project

Add SunKit using its public repository URL: `https://github.com/JarvanSun/SunKit.git`.

Use the `main` branch to add the package.

### XcodeGen (`project.yml`)

```yaml
packages:
  SunKit:
    url: https://github.com/JarvanSun/SunKit.git
    branch: main

targets:
  MyApp:
    dependencies:
      - package: SunKit
        product: SunCore
      - package: SunKit
        product: SunUserInterface
```

### Swift package (`Package.swift`)

```swift
dependencies: [
    .package(url: "https://github.com/JarvanSun/SunKit.git", branch: "main")
],
targets: [
    .target(
        name: "MyFeature",
        dependencies: [
            .product(name: "SunCore", package: "SunKit"),
            .product(name: "SunUserInterface", package: "SunKit"),
        ]
    )
]
```

### Xcode

File › Add Package Dependencies…, enter `https://github.com/JarvanSun/SunKit.git`, choose
the **Branch** dependency rule with `main`, then add `SunCore` and `SunUserInterface` to the app
target.

### A feature with SunUserInterface routing

```swift
import SunUserInterface
import SwiftUI

enum ProductDestination: FeatureDestination {
    case root
    case detail(productID: Int)
}

@Observable
final class ProductRouter: FeatureRouting {
    var presentation: FeaturePresentation<ProductDestination>?
    var path: [ProductDestination] = []

    func view(for destination: ProductDestination) -> ProductDestinationView {
        ProductDestinationView(destination: destination)
    }
}

struct ProductHostView: FeatureHost {
    let featureRouter: ProductRouter

    var root: some View {
        ProductView()
            .navigationTitle("Products")
    }
}
```

Rows push with `NavigationLink(value: ProductDestination.detail(productID:))`; code and deep links
call `featureRouter.route(to:)`.

### App-specific dimensions

The package only names generic sizes. An app declares its own tokens and reads them through the same
environment value:

```swift
extension DimensionToken {
    static let thumbnail: Self = "thumbnail"
}

extension DimensionStyling {
    var thumbnail: CGFloat { value(for: .thumbnail, default: 64) }
}

// DimensionTokens.json in the app bundle: { "spaceSmall": 8, "thumbnail": 64 }
// Inject once at the root: .environment(\.dimensions, DimensionStyle(tokens: DimensionTokens(.main)))
// Read anywhere: @Environment(\.dimensions) private var dimensions … dimensions.thumbnail
```

## Development

```sh
swift build
swift test
xcrun swift-format lint --strict --recursive Package.swift Sources Tests
```

- Follow the [Google Swift Style Guide](https://google.github.io/swift/) with four-space indentation
  and 100 columns; `.swift-format` holds the automated part.
- One public type per file; private helpers that serve only that file may stay beside it.
- Tests use Swift Testing, one behavior per test, named `methodWhenConditionThenExpectedResult`, with
  `// Given`, `// When`, `// Then` sections.
- Every file keeps its header and author.
- Release by tagging `MAJOR.MINOR.PATCH` (no `v` prefix) on `main`.
