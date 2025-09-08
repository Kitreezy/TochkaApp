//
//  PlaceCard.swift
//  DesignSystem
//
//  Created by Artem Rodionov on 14.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct PlaceCard: View {
    let title: String
    let subtitle: String
    let distance: String
    let rating: String
    let gradient: LinearGradient
    let icon: String
    let isActive: Bool
    let action: () -> Void
    
    public init(
        title: String,
        subtitle: String,
        distance: String,
        rating: String,
        gradient: LinearGradient,
        icon: String,
        isActive: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.distance = distance
        self.rating = rating
        self.gradient = gradient
        self.icon = icon
        self.isActive = isActive
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Иконка места с градиентом (как в HTML)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(gradient)
                        .frame(width: 48, height: 48)
                        .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
                    
                    Text(icon)
                        .font(.system(size: 20))
                }
                
                // Информация о месте
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Text(distance)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.primaryBlue)
                        
                        Text(rating)
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
            }
            .padding(12)
            .background(
                Color.backgroundCard
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isActive ? Color.primaryBlue : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .cornerRadius(12)
            .shadow(color: isActive ? Color.primaryBlue.opacity(0.2) : .shadowColor, radius: 8, x: 0, y: 4)
        }
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}
