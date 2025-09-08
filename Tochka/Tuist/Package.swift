// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers

    let packageSettings = PackageSettings()
#endif

let package = Package(
    name: "TochkaPackage",
    platforms: [
        .iOS(.v16)
    ],
    dependencies: [
        // Только инструменты для Tuist, НЕ для проекта
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.54.0")
    ],
    targets: []
)
