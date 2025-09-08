import ProjectDescription

// При использовании Xcode's default integration (packages в Project.swift)
// Dependencies.swift остается пустым
let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies([]),
    platforms: [.iOS]
)

// MARK: - Заметки
/*
Используем Xcode's default integration вместо Tuist XcodeProj-based:
- Все зависимости в Project.swift в секции packages
- Ссылки через .package(product: "...", type: .runtime)
- Dependencies.swift остается пустым
*/
