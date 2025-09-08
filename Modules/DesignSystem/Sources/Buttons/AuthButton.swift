//
//  AuthButton.swift
//  DesignSystem
//
//  Created by Artem Rodionov on 15.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

// MARK: - Универсальная кнопка для авторизации
public struct AuthButton: View {
    let title: String
    let isLoading: Bool
    let isEnabled: Bool
    let style: AuthButtonStyle
    let action: () -> Void
    
    public enum AuthButtonStyle {
        case primary
        case apple
        case google
        
        var backgroundColor: LinearGradient {
            switch self {
            case .primary:
                return AppGradients.appleBlue
            case .apple:
                return AppGradients.black
            case .google:
                return AppGradients.white
            }
        }
        
        var disabledBackground: LinearGradient {
            AppGradients.disabledBackground
        }
        
        var textColor: Color {
            switch self {
            case .primary, .apple:
                return .white
            case .google:
                return .black
            }
        }
        
        var borderColor: Color? {
            switch self {
            case .google:
                return Color.gray.opacity(0.3)
            default:
                return nil
            }
        }
        
        var icon: String? {
            switch self {
            case .primary:
                return nil
            case .apple:
                return "appleLogo"
            case .google:
                return "googleLogo"
            }
        }
        
        var shadowColor: Color {
            switch self {
            case .primary, .apple:
                return .black.opacity(0.15)
            case .google:
                return .black.opacity(0.1)
            }
        }
    }
    
    public init(
        title: String,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        style: AuthButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Логотип
                if let logoImage = style.icon {
                    Image(logoImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .opacity(isLoading ? 0.6 : 1.0)
                }
                
                // Текст или индикатор загрузки
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.textColor))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(style.textColor)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isEnabled ? style.backgroundColor : style.disabledBackground)
                    .overlay(
                        // Граница для Google кнопки
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                style.borderColor ?? Color.clear,
                                lineWidth: style.borderColor != nil ? 1 : 0
                            )
                    )
            )
            .shadow(
                color: isEnabled ? style.shadowColor : .clear,
                radius: isEnabled ? 8 : 0,
                x: 0,
                y: isEnabled ? 4 : 0
            )
        }
        .disabled(!isEnabled || isLoading)
        .scaleEffect(isEnabled ? 1.0 : 0.98)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .animation(.easeInOut(duration: 0.1), value: isEnabled)
    }
}

// MARK: - Convenience методы для легкого использования
public extension AuthButton {
    static func primary(
        title: String,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> AuthButton {
        AuthButton(
            title: title,
            isLoading: isLoading,
            isEnabled: isEnabled,
            style: .primary,
            action: action
        )
    }
    
    static func apple(
        title: String = "Войти через Apple",
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> AuthButton {
        AuthButton(
            title: title,
            isLoading: isLoading,
            style: .apple,
            action: action
        )
    }
    
    static func google(
        title: String = "Войти через Google",
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> AuthButton {
        AuthButton(
            title: title,
            isLoading: isLoading,
            style: .google,
            action: action
        )
    }
}

// MARK: - Preview
struct AuthButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            // Основная кнопка
            AuthButton(
                title: "Войти",
                isEnabled: true,
                style: .primary
            ) {}
            
            // Загрузка
            AuthButton(
                title: "Создать аккаунт",
                isLoading: true,
                style: .primary
            ) {}
            
            // Неактивная
            AuthButton(
                title: "Войти",
                isEnabled: false,
                style: .primary
            ) {}
            
            // Apple
            AuthButton(
                title: "Войти через Apple",
                style: .apple
            ) {}
            
            // Google
            AuthButton(
                title: "Войти через Google",
                style: .google
            ) {}
        }
        .padding()
        .background(Color.accentGreen)
    }
}
