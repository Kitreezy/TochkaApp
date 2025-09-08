//
//  ModernButton.swift
//  DesignSystem
//
//  Created by Artem Rodionov on 15.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct ModernButton: View {
    let title: String
    let isLoading: Bool
    let isDisabled: Bool
    let style: ButtonStyle
    let action: () -> Void
    
    public enum ButtonStyle {
        case primary
        case secondary
        case accent
    }
    
    public init(
        title: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        style: ButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(textColor)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(backgroundColor)
            .cornerRadius(16)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
        }
        .disabled(isDisabled || isLoading)
        .scaleEffect(isDisabled ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .animation(.easeInOut(duration: 0.1), value: isDisabled)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return isDisabled ? Color.textSecondary.opacity(0.3) : Color.primaryBlue
        case .secondary:
            return Color.backgroundCard
        case .accent:
            return isDisabled ? Color.textSecondary.opacity(0.3) : Color.accentGreen
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .accent:
            return Color.textOnDark
        case .secondary:
            return Color.primaryBlue
        }
    }
    
    private var shadowColor: Color {
        isDisabled ? .clear : .shadowColor
    }
    
    private var shadowRadius: CGFloat {
        isDisabled ? 0 : 8
    }
    
    private var shadowY: CGFloat {
        isDisabled ? 0 : 4
    }
}
