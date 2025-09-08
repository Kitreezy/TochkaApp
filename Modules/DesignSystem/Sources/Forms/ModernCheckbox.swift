//
//  ModernCheckbox.swift
//  DesignSystem
//
//  Created by Artem Rodionov on 17.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct ModernCheckbox: View {
    @Binding var isChecked: Bool
    let size: CGFloat
    let cornerRadius: CGFloat
    let checkedColor: Color
    let uncheckedColor: Color
    let borderColor: Color
    let checkmarkColor: Color
    
    public init(
        isChecked: Binding<Bool>,
        size: CGFloat = 20,
        cornerRadius: CGFloat = 4,
        checkedColor: Color = Color.primaryBlue,
        uncheckedColor: Color = Color.white,
        borderColor: Color = Color.gray.opacity(0.5),
        checkmarkColor: Color = Color.white
    ) {
        self._isChecked = isChecked
        self.size = size
        self.cornerRadius = cornerRadius
        self.checkedColor = checkedColor
        self.uncheckedColor = uncheckedColor
        self.borderColor = borderColor
        self.checkmarkColor = checkmarkColor
    }
    
    public var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isChecked.toggle()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isChecked ? checkedColor : uncheckedColor)
                    .frame(width: size, height: size)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                isChecked ? checkedColor : borderColor,
                                lineWidth: 2
                            )
                    )
                
                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: size * 0.6, weight: .bold))
                        .foregroundColor(checkmarkColor)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .scaleEffect(isChecked ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isChecked)
    }
}

// MARK: - Предустановленные стили
public extension ModernCheckbox {
    // Стандартный чекбокс для форм
    static func standard(isChecked: Binding<Bool>) -> ModernCheckbox {
        ModernCheckbox(isChecked: isChecked)
    }
    
    // Маленький чекбокс
    static func small(isChecked: Binding<Bool>) -> ModernCheckbox {
        ModernCheckbox(
            isChecked: isChecked,
            size: 16,
            cornerRadius: 3
        )
    }
    
    // Большой чекбокс
    static func large(isChecked: Binding<Bool>) -> ModernCheckbox {
        ModernCheckbox(
            isChecked: isChecked,
            size: 24,
            cornerRadius: 6
        )
    }
    
    // Чекбокс с акцентным цветом
    static func accent(isChecked: Binding<Bool>) -> ModernCheckbox {
        ModernCheckbox(
            isChecked: isChecked,
            checkedColor: Color.accentGreen
        )
    }
}

// MARK: - Checkbox с текстом
public struct CheckboxWithText: View {
    @Binding var isChecked: Bool
    let text: String
    let textColor: Color
    let fontSize: CGFloat
    let spacing: CGFloat
    
    public init(
        isChecked: Binding<Bool>,
        text: String,
        textColor: Color = Color.black.opacity(0.7),
        fontSize: CGFloat = 14,
        spacing: CGFloat = 12
    ) {
        self._isChecked = isChecked
        self.text = text
        self.textColor = textColor
        self.fontSize = fontSize
        self.spacing = spacing
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            ModernCheckbox.standard(isChecked: $isChecked)
                .padding(.top, 2)
            
            Text(text)
                .font(.system(size: fontSize))
                .foregroundColor(textColor)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

// MARK: - Checkbox с атрибутированным текстом
public struct CheckboxWithAttributedText: View {
    @Binding var isChecked: Bool
    let attributedText: Text
    let spacing: CGFloat
    
    public init(
        isChecked: Binding<Bool>,
        attributedText: Text,
        spacing: CGFloat = 12
    ) {
        self._isChecked = isChecked
        self.attributedText = attributedText
        self.spacing = spacing
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            ModernCheckbox.standard(isChecked: $isChecked)
                .padding(.top, 2)
            
            attributedText
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}
