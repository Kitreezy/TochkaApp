//
//  DecorativeElements.swift
//  DesignSystem
//
//  Created by Artem Rodionov on 17.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct DecorativeElements {
    
    // MARK: - Welcome Elements
    public static var welcomeElements: some View {
        ForEach(0..<8, id: \.self) { index in
            FloatingDot(
                size: CGFloat.random(in: 4...8),
                startPosition: (
                    Double.random(in: 0.1...0.9),
                    Double.random(in: 0.1...0.9)
                ),
                animationDelay: Double(index) * 0.8,
                color: Color.black.opacity(Double.random(in: 0.1...0.3))
            )
        }
    }
    
    // MARK: - Auth Elements
    public static var authElements: some View {
        ForEach(0..<6, id: \.self) { index in
            let positions = [(0.1, 0.2), (0.9, 0.3), (0.2, 0.8), (0.8, 0.7), (0.5, 0.1), (0.3, 0.6)]
            
            FloatingAuthDot(
                position: positions[index],
                animationDelay: Double(index) * 1.5
            )
        }
    }
}

// MARK: - Floating Dot (for Welcome screen)
private struct FloatingDot: View {
    let size: CGFloat
    let startPosition: (Double, Double)
    let animationDelay: Double
    let color: Color
    
    @State private var position: CGPoint = .zero
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .scaleEffect(scale)
                .opacity(opacity)
                .position(position)
                .onAppear {
                    startAnimation(in: geometry.size)
                }
        }
    }
    
    private func startAnimation(in size: CGSize) {
        // Начальная позиция
        position = CGPoint(
            x: size.width * startPosition.0,
            y: size.height * startPosition.1
        )
        
        // Появление с задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
            withAnimation(.easeOut(duration: 1.0)) {
                opacity = 1.0
                scale = 1.0
            }
            
            // Начинаем движение
            startFloating(in: size)
            
            // Исчезаем через случайное время
            let disappearDelay = Double.random(in: 4.0...8.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + disappearDelay) {
                withAnimation(.easeIn(duration: 1.5)) {
                    opacity = 0
                    scale = 0.5
                }
            }
        }
    }
    
    private func startFloating(in size: CGSize) {
        let duration = Double.random(in: 8.0...12.0)
        let endPosition = CGPoint(
            x: CGFloat.random(in: 0...size.width),
            y: CGFloat.random(in: 0...size.height)
        )
        
        withAnimation(
            .easeInOut(duration: duration)
            .repeatForever(autoreverses: true)
        ) {
            position = endPosition
        }
    }
}

// MARK: - Floating Auth Dot (for Auth screens)
private struct FloatingAuthDot: View {
    let position: (Double, Double)
    let animationDelay: Double
    @State private var opacity: Double = 0.2
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .fill(Color.primaryBlue.opacity(opacity))
                .frame(width: 6, height: 6)
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
                .offset(
                    x: geometry.size.width * position.0,
                    y: geometry.size.height * position.1
                )
                .animation(
                    Animation.easeInOut(duration: 6)
                        .repeatForever()
                        .delay(animationDelay),
                    value: opacity
                )
                .animation(
                    Animation.linear(duration: 8)
                        .repeatForever(autoreverses: false)
                        .delay(animationDelay),
                    value: rotation
                )
                .onAppear {
                    opacity = 0.6
                    scale = 1.2
                    rotation = 360
                }
        }
    }
}
