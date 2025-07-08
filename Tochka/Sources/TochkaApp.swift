import SwiftUI
import Core

@main
struct TochkaApp: App {
    
    init() {
        configureFirebase()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    setupAppearance()
                }
        }
    }
    
    // MARK: - Configuration
    
    private func configureFirebase() {
        print("🚀 Tochka App запущено")
    }
    
    private func setupAppearance() {
        // Настройка глобального внешнего вида
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.systemBackground
        navBarAppearance.shadowColor = UIColor.separator
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        // Настройка TabBar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
