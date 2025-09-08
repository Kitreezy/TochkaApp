//
//  AuthNavigationHeader.swift
//  ActivityFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct AuthNavigationHeader<Content: View>: View {
    let navigationTitle: String
    let headerTitle: String
    let headerSubtitle: String
    let onBack: () -> Void
    let content: () -> Content
    
    public init(
        navigationTitle: String,
        headerTitle: String,
        headerSubtitle: String,
        onBack: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.navigationTitle = navigationTitle
        self.headerTitle = headerTitle
        self.headerSubtitle = headerSubtitle
        self.onBack = onBack
        self.content = content
    }
    
    public var body: some View {
        CustomNavigationHeader(
            title: navigationTitle,
            backgroundColor: .accentGreen,
            onBack: onBack
        ) {
            ZStack {
                DecorativeElements.authElements
                
                ScrollView {
                    VStack(spacing: 32) {
                        Spacer(minLength: 10)
                        
                        // Встроенный header
                        headerSection
                        
                        // Контент от пользователя
                        content()
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 32)
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text(headerTitle)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.black)
            
            Text(headerSubtitle)
                .font(.system(size: 16))
                .foregroundStyle(.black.opacity(0.7))
        }
    }
}

// MARK: - Convenience Methods
public extension AuthNavigationHeader {
    
    /// Создает навигационный заголовок для входа
    static func login(
        onBack: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) -> AuthNavigationHeader<Content> {
        AuthNavigationHeader(
            navigationTitle: "Добро пожаловать",
            headerTitle: "Добро пожаловать",
            headerSubtitle: "Войдите в свой аккаунт Tochka",
            onBack: onBack,
            content: content
        )
    }
    
    /// Создает навигационный заголовок для регистрации
    static func registration(
        onBack: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) -> AuthNavigationHeader<Content> {
        AuthNavigationHeader(
            navigationTitle: "Создать аккаунт",
            headerTitle: "Создать аккаунт",
            headerSubtitle: "Присоединяйтесь к сообществу Tochka",
            onBack: onBack,
            content: content
        )
    }
}
