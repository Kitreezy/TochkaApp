// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "TochkaPackage",
    platforms: [
        .iOS(.v15)
    ],
    products: [],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            from: "10.18.0"
        ),
        
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.54.0"
        ),
        
        .package(
            url: "https://github.com/onevcat/Kingfisher.git",
            from: "7.10.0"
        )
    ],
    targets: []
)

// MARK: - Заметки о зависимостях

/*
Firebase:
- FirebaseAuth: Авторизация пользователей
- FirebaseFirestore: База данных для активностей и чатов
- FirebaseStorage: Хранение изображений
- FirebaseMessaging: Push-уведомления

SwiftLint:
- Автоматическая проверка стиля кода
- Поддержание единообразия в команде

Kingfisher:
- Асинхронная загрузка и кэширование изображений
- Поддержка SwiftUI
- Отличная производительность
*/
