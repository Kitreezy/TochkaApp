//
//  MapControlsView.swift
//  MapFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct MapControlsView: View {
    let onLocationTap: () -> Void
    let onZoomIn: () -> Void
    let onZoomOut: () -> Void
    
    public init(
        onLocationTap: @escaping () -> Void,
        onZoomIn: @escaping () -> Void,
        onZoomOut: @escaping () -> Void
    ) {
        self.onLocationTap = onLocationTap
        self.onZoomIn = onZoomIn
        self.onZoomOut = onZoomOut
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            // Кнопка геолокации
            MapControlButton(icon: "location.fill", color: .primaryBlue) {
                onLocationTap()
            }
            
            // Кнопка увеличения
            MapControlButton(icon: "plus", color: .primaryBlue) {
                onZoomIn()
            }
            
            // Кнопка уменьшения
            MapControlButton(icon: "minus", color: .primaryBlue) {
                onZoomOut()
            }
        }
    }
}

// MARK: - MapControlButton (вспомогательный компонент)
struct MapControlButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 12)
                )
                .shadow(color: .shadowColor, radius: 8, x: 0, y: 4)
        }
    }
}
