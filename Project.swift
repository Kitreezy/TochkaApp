import ProjectDescription

let project = Project(
    name: "Tochka",
    organizationName: "com.tochka.app",
    
    packages: [
        .remote(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            requirement: .upToNextMajor(from: "10.18.0")
        ),
        .remote(
            url: "https://github.com/onevcat/Kingfisher.git",
            requirement: .upToNextMajor(from: "7.10.0")
        )
    ],
    
    settings: .settings(
        base: [
//            "DEVELOPMENT_TEAM": "YOUR_TEAM_ID", // Замени на свой Team ID
            "CODE_SIGN_STYLE": "Automatic",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "SWIFT_VERSION": "5.9",
            "OTHER_LDFLAGS": "$(inherited) -ObjC" // Для Firebase
        ],
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ]
    ),
    
    targets: [
        // MARK: - Core Module
        .target(
            name: "Core",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.core",
            deploymentTargets: .iOS("16.0"),
            sources: ["Modules/Core/Sources/**"],
            dependencies: [
                // Ссылки на продукты из packages
                .package(product: "FirebaseAuth", type: .runtime),
                .package(product: "FirebaseFirestore", type: .runtime),
                .package(product: "FirebaseStorage", type: .runtime),
                .package(product: "Kingfisher", type: .runtime)
            ]
        ),
        
        // MARK: - DesingSystem (общие UI компоненты)
        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.designsystem",
            deploymentTargets: .iOS("16.0"),
            sources: ["Modules/DesignSystem/Sources/**"],
            resources: ["Modules/DesignSystem/Resources/**"],
            dependencies: [
                .target(name: "Core")
            ]
        ),
        
        // MARK: - AuthFeature (авторизация)
        .target(
            name: "AuthFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.authfeature",
            deploymentTargets: .iOS("16.0"),
            sources: ["Modules/AuthFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ]
        ),
        
        // MARK: - MapFeature (карта и геолокация)
        .target(
            name: "MapFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.mapfeature",
            deploymentTargets: .iOS("16.0"),
            sources: ["Modules/MapFeature/Sources/**"],
            resources: ["Modules/MapFeature/Resources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.9",
                    "ENABLE_TESTING_SEARCH_PATHS": "YES"
                ]
            )
        ),
        
        // MARK: - ActivityFeature (создание и просмотр активностей)
        .target(
            name: "ActivityFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.activityfeature",
            deploymentTargets: .iOS("16.0"),
            sources: ["Modules/ActivityFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ]
        ),
        
        // MARK: - ChatFeature (чат в активности)
        .target(
            name: "ChatFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.chatfeature",
            deploymentTargets: .iOS("16.0"),
            sources: ["Modules/ChatFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ]
        ),
        
        
        // MARK: - ProfileFeature (профиль пользователя)
        .target(
            name: "ProfileFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.profilefeature",
            deploymentTargets: .iOS("16.0"),
            sources: ["Modules/ProfileFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ]
        ),
        
        // MARK: - Основное приложение
        .target(
            name: "Tochka",
            destinations: .iOS,
            product: .app,
            bundleId: "com.tochka.app",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen",
                    "NSLocationWhenInUseUsageDescription": "Приложение использует геолокацию для поиска активностей рядом с вами",
                    "NSLocationAlwaysAndWhenInUseUsageDescription": "Приложение использует геолокацию для поиска активностей рядом с вами",
                    "NSCameraUsageDescription": "Для добавления фото в чат и профиль",
                    "NSPhotoLibraryUsageDescription": "Для выбора фото из галереи"
                ]
            ),
            sources: ["Tochka/Sources/**"],
            resources: ["Tochka/Resources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "DesignSystem"),
                .target(name: "AuthFeature"),
                .target(name: "MapFeature"),
                .target(name: "ActivityFeature"),
                .target(name: "ChatFeature"),
                .target(name: "ProfileFeature")
            ]
        ),

        // MARK: - Unit Tests
        .target(
            name: "TochkaTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.tochka.app.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tochka/Tests/**"],
            dependencies: [
                .target(name: "AuthFeature"),
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ]
        )
    ]
)
