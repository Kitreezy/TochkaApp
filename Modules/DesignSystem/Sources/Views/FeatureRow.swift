//
//  FeatureRow.swift
//  DesignSystem
//
//  Created by Artem Rodionov on 15.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI

public struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: LinearGradient
    @Binding var isVisible: Bool
    
    public init(
        icon: String,
        title: String,
        subtitle: String,
        gradient: LinearGradient,
        isVisible: Binding<Bool>
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.gradient = gradient
        self._isVisible = isVisible
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            // Иконка с градиентом (как в HTML)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(gradient)
                    .frame(width: 48, height: 48)
                    .shadow(color: .shadowColor, radius: 8, x: 0, y: 4)
                
                Text(icon)
                    .font(.system(size: 20))
            }
            .scaleEffect(isVisible ? 1.0 : 0.5)
            .opacity(isVisible ? 1.0 : 0.0)
            
            // Текст
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.leading)
            }
            .offset(x: isVisible ? 0 : 30)
            .opacity(isVisible ? 1.0 : 0.0)
            
            Spacer()
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isVisible)
    }
}
