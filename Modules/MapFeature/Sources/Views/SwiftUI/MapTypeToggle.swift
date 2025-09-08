//
//  MapTypeToggle.swift
//  MapFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import MapKit
import Core

public struct MapTypeToggle: View {
    @Binding var mapType: MKMapType
    
    public init(mapType: Binding<MKMapType>) {
        self._mapType = mapType
    }
    
    public var body: some View {
        HStack(spacing: 2) {
            MapTypeButton(
                title: "Карта",
                isSelected: mapType == .standard
            ) {
                mapType = .standard
            }
            
            MapTypeButton(
                title: "Спутник",
                isSelected: mapType == .hybrid
            ) {
                mapType = .hybrid
            }
        }
        .padding(2)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 8)
        )
        .shadow(color: .shadowColor, radius: 8, x: 0, y: 4)
    }
}

// MARK: - MapTypeButton (вспомогательный компонент)
struct MapTypeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? Color.primaryBlue : Color.clear,
                    in: RoundedRectangle(cornerRadius: 6)
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
