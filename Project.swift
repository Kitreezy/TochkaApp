import ProjectDescription

// MARK: - Project Configuration

let project = Project(
    name: "Tochka",
    organizationName: "com.tochka.app",
    
    // MARK: - Settings
    settings: .settings(
        base: [
//            "DEVELOPMENT_TEAM": "YOUR_TEAM_ID", // Замени на свой Team ID
//            "CODE_SIGN_STYLE": "Automatic",
            "IPHONEOS_DEPLOYMENT_TARGET": "15.0",
            "SWIFT_VERSION": "5.9"
        ],
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ]
    ),
    
    // MARK: - Targets
    targets: [
        // Основное приложение
        .target(
            name: "Tochka",
            destinations: .iOS,
            product: .app,
            bundleId: "com.tochka.app",
            deploymentTargets: .iOS("15.0"),
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
                .target(name: "MapFeature"),
                .target(name: "ActivityFeature"),
                .target(name: "ChatFeature"),
                .target(name: "AuthFeature"),
                .target(name: "ProfileFeature"),
                .target(name: "DesignSystem")
            ]
        ),
        
        // MARK: - Core Module
        .target(
            name: "Core",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.core",
            deploymentTargets: .iOS("15.0"),
            sources: ["Modules/Core/Sources/**"],
            dependencies: [
                // Firebase зависимости добавим позже
            ]
        ),
        
        // MARK: - Design System
        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.designsystem",
            deploymentTargets: .iOS("15.0"),
            sources: ["Modules/DesignSystem/Sources/**"],
            resources: ["Modules/DesignSystem/Resources/**"],
            dependencies: [
                .target(name: "Core")
            ]
        ),
        
        // MARK: - Features
        .target(
            name: "MapFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.mapfeature",
            deploymentTargets: .iOS("15.0"),
            sources: ["Modules/MapFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ]
        ),
        
        .target(
            name: "ActivityFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.activityfeature",
            deploymentTargets: .iOS("15.0"),
            sources: ["Modules/ActivityFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ]
        ),
        
        .target(
            name: "ChatFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.chatfeature",
            deploymentTargets: .iOS("15.0"),
            sources: ["Modules/ChatFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ]
        ),
        
        .target(
            name: "AuthFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.authfeature",
            deploymentTargets: .iOS("15.0"),
            sources: ["Modules/AuthFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ]
        ),
        
        .target(
            name: "ProfileFeature",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.tochka.app.profilefeature",
            deploymentTargets: .iOS("15.0"),
            sources: ["Modules/ProfileFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "DesignSystem")
            ]
        )
    ]
)
