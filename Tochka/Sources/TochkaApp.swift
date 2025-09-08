//
//  TochkaApp.swift
//  Tochka
//
//  Created by Artem Rodionov on 08.07.2025.
//

import SwiftUI
import Core

@main
struct TochkaApp: App {
    
    init() {
        FirebaseManager.shared.configure()
        print("🚀 Tochka приложение запущено")
        print("📱 Тестирование авторизации...")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
