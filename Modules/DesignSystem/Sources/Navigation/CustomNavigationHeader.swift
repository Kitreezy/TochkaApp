//
//  CustomNavigationHeader.swift
//  ActivityFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct CustomNavigationHeader<Content: View>: View {
    let title: String
    let backgroundColor: Color
    let onBack: (() -> Void)?
    let content: () -> Content
    
    public init(
        title: String,
        backgroundColor: Color = .accentGreen,
        onBack: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.onBack = onBack
        self.content = content
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                content()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(backgroundColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarBackButtonHidden(onBack != nil)
            .toolbar {
                if let onBack = onBack {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: onBack) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Convenience Extensions
public extension CustomNavigationHeader {
    
    /// Создает навигационный заголовок для экранов авторизации
    static func auth(
        title: String,
        onBack: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) -> CustomNavigationHeader<Content> {
        CustomNavigationHeader(
            title: title,
            backgroundColor: .accentGreen,
            onBack: onBack,
            content: content
        )
    }
    
    /// Создает навигационный заголовок без кнопки назад
    static func simple(
        title: String,
        backgroundColor: Color = .backgroundMain,
        @ViewBuilder content: @escaping () -> Content
    ) -> CustomNavigationHeader<Content> {
        CustomNavigationHeader(
            title: title,
            backgroundColor: backgroundColor,
            onBack: nil,
            content: content
        )
    }
}
