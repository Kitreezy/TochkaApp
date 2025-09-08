//
//  ProfileHeader.swift
//  DesignSystem
//
//  Created by Artem Rodionov on 14.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct ProfileHeader: View {
    let name: String
    let level: String
    let avatar: String
    let isVerified: Bool
    let stats: [(String, String)] // (значение, название)
    let onAddFriend: () -> Void
    let onMore: () -> Void
    
    public init(
        name: String,
        level: String,
        avatar: String,
        isVerified: Bool = false,
        stats: [(String, String)],
        onAddFriend: @escaping () -> Void,
        onMore: @escaping () -> Void
    ) {
        self.name = name
        self.level = level
        self.avatar = avatar
        self.isVerified = isVerified
        self.stats = stats
        self.onAddFriend = onAddFriend
        self.onMore = onMore
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // Аватар и имя (как в HTML)
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.gradientPurple)
                        .frame(width: 60, height: 60)
                        .shadow(color: .shadowColor, radius: 8, x: 0, y: 4)
                    
                    Text(avatar)
                        .font(.system(size: 24))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text(name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        if isVerified {
                            ZStack {
                                Circle()
                                    .fill(Color.accentGreen)
                                    .frame(width: 16, height: 16)
                                
                                Text("✓")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.textOnDark)
                            }
                        }
                    }
                    
                    Text(level)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
            }
            
            // Статистика в grid (как в HTML)
            HStack(spacing: 12) {
                ForEach(Array(stats.enumerated()), id: \.offset) { index, stat in
                    VStack(spacing: 4) {
                        Text(stat.0)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text(stat.1.uppercased())
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.textSecondary)
                            .tracking(0.5)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.backgroundMain)
                    .cornerRadius(8)
                }
            }
            
            // Кнопки действий (как в HTML)
            HStack(spacing: 8) {
                ModernButton(
                    title: "+ Add Friend",
                    style: .accent
                ) {
                    onAddFriend()
                }
                
                Button(action: onMore) {
                    Text("⋯")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.textSecondary)
                        .frame(width: 44, height: 56)
                        .background(Color.backgroundMain)
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color.backgroundCard)
        .cornerRadius(16)
        .shadow(color: .shadowColor, radius: 8, x: 0, y: 4)
    }
}
