//
//  PlaceholderViews.swift
//  Tochka
//
//  Created by Artem Rodionov on 08.07.2025.
//

import SwiftUI
import Core
import MapFeature

// MARK: - ActivityListView остается заглушкой
struct ActivityListView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "list.bullet.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Активности")
                    .font(.title)
                
                Text("Список ближайших активностей")
                    .foregroundColor(.secondary)
                
                // Пример активности
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("🍕")
                            .font(.title2)
                        Text("Пицца в центре")
                            .font(.headline)
                        Spacer()
                    }
                    Text("Сегодня в 19:00")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Собираемся поесть пиццу в центре города")
                        .font(.body)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .navigationTitle("Активности")
        }
    }
}

// MARK: - ProfileView остается заглушкой
struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                
                Text("Профиль")
                    .font(.title)
                
                if let user = authManager.currentUser {
                    VStack(spacing: 8) {
                        Text("Добро пожаловать!")
                            .foregroundColor(.secondary)
                        
                        Text(user.email ?? "Неизвестный email")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("UID: \(user.uid)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        
                        Text("✅ Firebase авторизация")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Button("Выйти") {
                    authManager.signOut()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Профиль")
            .padding()
        }
    }
}
