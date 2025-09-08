//
//  PlaceCardView.swift
//  MapFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core
import DesignSystem
import MapKit

public struct PlaceCardView: View {
    let place: Place
    let userLocation: CLLocationCoordinate2D?
    let isActive: Bool
    let action: () -> Void
    
    public init(
        place: Place,
        userLocation: CLLocationCoordinate2D? = nil,
        isActive: Bool = false,
        action: @escaping () -> Void
    ) {
        self.place = place
        self.userLocation = userLocation
        self.isActive = isActive
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Иконка места с градиентом
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(place.category.gradient)
                        .frame(width: 48, height: 48)
                        .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
                    
                    Text(place.category.emoji)
                        .font(.system(size: 20))
                }
                
                // Информация о месте
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    
                    Text(place.description)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        // Расстояние
                        if let userLocation = userLocation {
                            Text(place.distanceDisplay(from: userLocation))
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.primaryBlue)
                        }
                        
                        // Рейтинг
                        Text(place.ratingDisplay)
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
            .shadow(
                color: isActive ? Color.primaryBlue.opacity(0.2) : .shadowColor,
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

// MARK: - Preview провайдеры для тестирования
#if DEBUG
struct MapUIComponents_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Search Bar
            MapSearchBarView(
                searchText: .constant(""),
                onFilterTap: {}
            )
            
            // Map Controls
            HStack {
                Spacer()
                MapControlsView(
                    onLocationTap: {},
                    onZoomIn: {},
                    onZoomOut: {}
                )
            }
            
            // Map Type Toggle
            MapTypeToggle(mapType: .constant(.standard))
            
            // Category Filter
            CategoryFilterView(
                selectedCategory: .constant(.all),
                onCategoryChanged: { _ in }
            )
            
            // Place Card
            PlaceCardView(
                place: Place.samplePlaces[0],
                userLocation: .rostovOnDon,
                isActive: true,
                action: {}
            )
            
            Spacer()
        }
        .padding()
        .background(Color.accentGreen)
    }
}
#endif
