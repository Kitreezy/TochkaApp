//
//  ModernTextFieldStyle.swift
//  DesignSystem
//
//  Created by Artem Rodionov on 15.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct ModernTextFieldStyle: TextFieldStyle {
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    public init(
        backgroundColor: Color = Color.white.opacity(0.9),
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 2
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .shadow(
                        color: .black.opacity(0.05),
                        radius: shadowRadius,
                        x: 0,
                        y: 1
                    )
            )
    }
}

// MARK: - Предустановленные стили
public extension ModernTextFieldStyle {
    // Стиль для экранов авторизации
    static var auth: ModernTextFieldStyle {
        ModernTextFieldStyle(
            backgroundColor: Color.white.opacity(0.9),
            cornerRadius: 12,
            shadowRadius: 2
        )
    }
    
    // Стиль для основного приложения
    static var primary: ModernTextFieldStyle {
        ModernTextFieldStyle(
            backgroundColor: Color.backgroundCard,
            cornerRadius: 12,
            shadowRadius: 4
        )
    }
    
    // Стиль для поиска
    static var search: ModernTextFieldStyle {
        ModernTextFieldStyle(
            backgroundColor: Color.white.opacity(0.95),
            cornerRadius: 20,
            shadowRadius: 8
        )
    }
}

// MARK: - Convenience extension для легкого использования
public extension View {
    func modernTextFieldStyle(_ style: ModernTextFieldStyle = .auth) -> some View {
        self.textFieldStyle(style)
    }
}
