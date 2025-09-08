//
//  ImprovedMapMarker.swift
//  MapFeature
//
//  Created by Artem Rodionov on 25.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

public struct ImprovedMapMarker: View {
    let place: Place
    let isSelected: Bool
    let isCluster: Bool
    let onTap: () -> Void
    
    public init(
        place: Place,
        isSelected: Bool,
        isCluster: Bool,
        onTap: @escaping () -> Void
    ) {
        self.place = place
        self.isSelected = isSelected
        self.isCluster = isCluster
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: onTap) {
            if isCluster {
                clusterMarker
            } else {
                singleMarker
            }
        }
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
    
    // MARK: - Cluster Marker
    private var clusterMarker: some View {
        VStack(spacing: 0) {
            ZStack {
                // Внешний круг (синий)
                Circle()
                    .fill(Color.primaryBlue)
                    .frame(width: 48, height: 48)
                    .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                
                // Внутренний круг (белый)
                Circle()
                    .fill(Color.white)
                    .frame(width: 36, height: 36)
                
                // Количество мест
                Text(extractClusterCount())
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.primaryBlue)
                
                // Обводка при выборе
                if isSelected {
                    Circle()
                        .stroke(Color.accentGreen, lineWidth: 3)
                        .frame(width: 52, height: 52)
                }
            }
            
            // Хвостик
            Triangle()
                .fill(Color.primaryBlue)
                .frame(width: 10, height: 6)
                .offset(y: -1)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
        }
    }
    
    // MARK: - Single Marker
    private var singleMarker: some View {
        VStack(spacing: 0) {
            ZStack {
                // Основной круг с градиентом категории
                Circle()
                    .fill(place.category.gradient)
                    .frame(width: isSelected ? 42 : 36, height: isSelected ? 42 : 36)
                    .shadow(
                        color: .black.opacity(0.3),
                        radius: isSelected ? 6 : 3,
                        x: 0,
                        y: isSelected ? 3 : 2
                    )
                
                // Иконка категории
                Text(place.category.emoji)
                    .font(.system(size: isSelected ? 16 : 14))
                
                // Обводка при выборе
                if isSelected {
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 46, height: 46)
                }
            }
            
            // Хвостик
            Triangle()
                .fill(place.category.gradient)
                .frame(width: 8, height: 5)
                .offset(y: -1)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
        }
    }
    
    // MARK: - Helper Methods
    private func extractClusterCount() -> String {
        // Извлекаем число из названия кластера "5 мест"
        let components = place.name.components(separatedBy: " ")
        return components.first ?? "?"
    }
}
