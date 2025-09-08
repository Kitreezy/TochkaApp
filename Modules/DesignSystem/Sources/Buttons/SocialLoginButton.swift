//
//  SocialLoginButton.swift
//  DesignSystem
//
//  Created by Artem Rodionov on 15.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct SocialLoginButton: View {
    let title: String
    let icon: String
    let backgroundColor: Color
    let action: () -> Void
    
    public init(
        title: String,
        icon: String,
        backgroundColor: Color,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(icon)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textOnDark)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(backgroundColor)
            .cornerRadius(16)
            .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
        }
        .scaleEffect(0.99)
        .animation(.easeInOut(duration: 0.1), value: true)
    }
}
