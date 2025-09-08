//
//  ShimmerLogo.swift
//  DesignSystem
//
//  Created by Artem Rodionov on 17.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct ShimmerLogo: View {
    let size: CGFloat
    @State private var shimmerOffset: CGFloat = -200
    
    public init(size: CGFloat = 200) {
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            // Основной контейнер с правильным радиусом как в HTML макете
            RoundedRectangle(cornerRadius: size * 0.25) // 25% от размера
                .fill(AppGradients.appleBlue)
                .frame(width: size, height: size)
                .overlay(
                    // Правильный shimmer эффект - блеск по диагонали от левого верхнего к правому нижнему
                    LinearGradient(
                        colors: [
                            .clear,
                            .clear,
                            .clear,
                            Color.white.opacity(0.1),
                            .clear,
                            .clear,
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: size * 0.25)
                    )
                    .offset(x: shimmerOffset, y: shimmerOffset)
                    .animation(
                        Animation.linear(duration: 3.0)
                            .repeatForever(autoreverses: false)
                            .delay(1.0),
                        value: shimmerOffset
                    )
                )
                .clipped()
            
            // Логотип - сначала попробуем загрузить из Assets, потом иконка
            Group {
                if let _ = UIImage(named: "tochka-logo") {
                    Image("tochka-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size * 0.6, height: size * 0.6)
                } else {
                    // Fallback на красивую иконку
                    Image(systemName: "location.fill")
                        .font(.system(size: size * 0.35, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            shimmerOffset = size + 100
        }
    }
}
