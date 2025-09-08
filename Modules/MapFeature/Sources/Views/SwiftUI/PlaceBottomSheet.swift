//
//  PlaceBottomSheet.swift
//  MapFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core
import DesignSystem
import CoreLocation

public struct PlaceBottomSheet: View {
    let places: [Place]
    let userLocation: CLLocationCoordinate2D?
    @Binding var selectedPlace: Place?
    @Binding var selectedCategory: PlaceCategory
    @State private var loadingRotation: Double = 0
    let isLoading: Bool
    let onPlaceSelected: (Place) -> Void
    let onCreateActivity: (Place) -> Void
    let onCategoryChanged: (PlaceCategory) -> Void
    let onShowPlaceDetail: (Place) -> Void
    
    // MARK: - State
    @State private var sheetPosition: SheetPosition = .collapsed
    @GestureState private var dragOffset: CGFloat = 0
    
    enum SheetPosition: CaseIterable {
        case collapsed, expanded
        
        func offset(screenHeight: CGFloat) -> CGFloat {
            switch self {
            case .collapsed:
                return screenHeight - 220
            case .expanded:
                return screenHeight * 0.15
            }
        }
        
        var maxHeight: CGFloat {
            switch self {
            case .collapsed:
                return 200
            case .expanded:
                return .infinity
            }
        }
    }
    
    public init(
        places: [Place],
        userLocation: CLLocationCoordinate2D?,
        selectedPlace: Binding<Place?>,
        selectedCategory: Binding<PlaceCategory>,
        isLoading: Bool = false,
        onPlaceSelected: @escaping (Place) -> Void,
        onCreateActivity: @escaping (Place) -> Void,
        onCategoryChanged: @escaping (PlaceCategory) -> Void,
        onShowPlaceDetail: @escaping (Place) -> Void
    ) {
        self.places = places
        self.userLocation = userLocation
        self._selectedPlace = selectedPlace
        self._selectedCategory = selectedCategory
        self.isLoading = isLoading 
        self.onPlaceSelected = onPlaceSelected
        self.onCreateActivity = onCreateActivity
        self.onCategoryChanged = onCategoryChanged
        self.onShowPlaceDetail = onShowPlaceDetail
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Drag Handle
                DragHandle(
                    onDragChanged: { _ in
                        // Живое обновление не нужно
                    },
                    onDragEnded: { translation in
                        handleDragEnd(translation: translation)
                    }
                )
                
                // Content
                contentView
                    .frame(maxHeight: sheetPosition.maxHeight)
            }
            .frame(maxWidth: .infinity)
            .background(sheetBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .shadowColor, radius: 16, x: 0, y: -4)
            .offset(y: sheetPosition.offset(screenHeight: geometry.size.height) + dragOffset)
            .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.8), value: sheetPosition)
        }
        .clipped()
    }
    
    // MARK: - Content View
    private var contentView: some View {
        Group {
            switch sheetPosition {
            case .collapsed:
                collapsedContent
            case .expanded:
                expandedContent
            }
        }
        .animation(.easeInOut(duration: 0.3), value: sheetPosition)
    }
    
    // MARK: - Background
    private var sheetBackground: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
    }
    
    // MARK: - Collapsed Content
    private var collapsedContent: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Места поблизости")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    if isLoading {
                        Text("Поиск мест...")
                            .font(.system(size: 14))
                            .foregroundColor(.primaryBlue)
                    } else {
                        Text("Найдено \(places.count) мест")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                if !isLoading {
                    Button("Показать все") {
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8)) {
                            sheetPosition = .expanded
                        }
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primaryBlue)
                }
            }
            .padding(.horizontal, 16)
            
            if isLoading {
                HStack(spacing: 12) {
                    // Маленький спиннер
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .primaryBlue))
                        .scaleEffect(1.0)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Загрузка мест...")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textPrimary)
                        
                        Text("Пожалуйста, подождите")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(height: 100)
            } else if !places.isEmpty {
                // Horizontal scroll как раньше
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(places.prefix(10)) { place in
                            CompactPlaceCard(
                                place: place,
                                userLocation: userLocation,
                                isActive: selectedPlace?.id == place.id
                            ) {
                                selectedPlace = place
                                onPlaceSelected(place)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: 100)
            } else {
                EmptyPlacesView()
                    .frame(height: 100)
            }
            
            Spacer(minLength: 20)
        }
        .frame(maxHeight: 180)
    }
    
    // MARK: - Expanded Content
    private var expandedContent: some View {
        VStack(spacing: 0) {
            // Header с кнопкой назад
            HStack {
                Button("Свернуть") {
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8)) {
                        sheetPosition = .collapsed
                    }
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primaryBlue)
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text("Все места")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    // ДОБАВИТЬ: статус в заголовке
                    if isLoading {
                        Text("Обновление...")
                            .font(.system(size: 12))
                            .foregroundColor(.primaryBlue)
                    } else {
                        Text("(\(places.count))")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                Color.clear.frame(width: 60)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .frame(height: 44)
            
            // CategoryFilter (только если не загружается)
            if !isLoading {
                CategoryFilterView(
                    selectedCategory: $selectedCategory,
                    onCategoryChanged: onCategoryChanged
                )
                .padding(.bottom, 8)
            }
            
            // Content с улучшенной загрузкой
            if isLoading {
                // ДОБАВИТЬ: красивый лоадер в центре
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Анимированный лоадер
                    ZStack {
                        Circle()
                            .stroke(Color.primaryBlue.opacity(0.2), lineWidth: 4)
                            .frame(width: 50, height: 50)
                        
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(Color.primaryBlue, lineWidth: 4)
                            .frame(width: 50, height: 50)
                            .rotationEffect(.degrees(loadingRotation))
                            .animation(
                                Animation.linear(duration: 1.0).repeatForever(autoreverses: false),
                                value: loadingRotation
                            )
                    }
                    .onAppear {
                        loadingRotation = 360
                    }
                    
                    VStack(spacing: 8) {
                        Text("Поиск мест...")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.textPrimary)
                        
                        Text("Ищем интересные места поблизости")
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)
            } else if !places.isEmpty {
                // List с местами
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(places) { place in
                            ExpandedPlaceCard(
                                place: place,
                                userLocation: userLocation,
                                isSelected: selectedPlace?.id == place.id,
                                onTap: {
                                    selectedPlace = place
                                    onPlaceSelected(place)
                                },
                                onShowDetail: {
                                    onShowPlaceDetail(place)
                                },
                                onCreateActivity: {
                                    onCreateActivity(place)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
                .transition(.opacity)
            } else {
                // Empty state
                EmptyPlacesView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
            }
        }
    }
    
    // MARK: - Drag Logic
    private func handleDragEnd(translation: CGFloat) {
        let threshold: CGFloat = 50
        
        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.8)) {
            if translation > threshold && sheetPosition == .expanded {
                sheetPosition = .collapsed
            } else if translation < -threshold && sheetPosition == .collapsed {
                sheetPosition = .expanded
            }
            // Иначе остаемся в текущем состоянии
        }
    }
}

// MARK: - Compact Place Card
struct CompactPlaceCard: View {
    let place: Place
    let userLocation: CLLocationCoordinate2D?
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                // Header
                HStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(place.category.gradient)
                            .frame(width: 28, height: 28)
                        
                        Text(place.category.emoji)
                            .font(.system(size: 14))
                    }
                    
                    Text(place.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                }
                
                // Description
                Text(place.description)
                    .font(.system(size: 11))
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Meta
                HStack(spacing: 8) {
                    if let userLocation = userLocation {
                        Text(place.distanceDisplay(from: userLocation))
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.primaryBlue)
                    }
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                    Text(place.ratingDisplay)
                        .font(.system(size: 10))
                        .foregroundColor(.orange)
                    
                    Spacer()
                }
            }
            .padding(10)
            .frame(width: 180, height: 90)
            .background(
                Color.backgroundCard
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                isActive ? Color.primaryBlue : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .cornerRadius(10)
            .shadow(
                color: isActive ? Color.primaryBlue.opacity(0.2) : .shadowColor,
                radius: 4,
                x: 0,
                y: 2
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

// MARK: - Expanded Place Card (тот же что был)
struct ExpandedPlaceCard: View {
    let place: Place
    let userLocation: CLLocationCoordinate2D?
    let isSelected: Bool
    let onTap: () -> Void
    let onShowDetail: () -> Void
    let onCreateActivity: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Main info
            HStack(spacing: 12) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(place.category.gradient)
                        .frame(width: 48, height: 48)
                        .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
                    
                    Text(place.category.emoji)
                        .font(.system(size: 20))
                }
                
                // Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)
                    
                    Text(place.description)
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                    
                    // Meta
                    HStack(spacing: 12) {
                        if let userLocation = userLocation {
                            HStack(spacing: 4) {
                                Image(systemName: "location")
                                    .font(.system(size: 12))
                                    .foregroundColor(.primaryBlue)
                                Text(place.distanceDisplay(from: userLocation))
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.primaryBlue)
                            }
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.orange)
                            Text(place.ratingDisplay)
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
                Spacer()
            }
            
            HStack(spacing: 8) {
                Button("Подробнее") {
                    onShowDetail()
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primaryBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.primaryBlue.opacity(0.1))
                .cornerRadius(8)
                
                Button("Создать активность") {
                    onCreateActivity()
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.accentGreen)
                .cornerRadius(8)
            }
        }
        .padding(16)
        .background(
            Color.backgroundCard
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected ? Color.primaryBlue : Color.clear,
                            lineWidth: 2
                        )
                )
        )
        .cornerRadius(12)
        .shadow(
            color: isSelected ? Color.primaryBlue.opacity(0.2) : .shadowColor,
            radius: 6,
            x: 0,
            y: 3
        )
        .onTapGesture {
            onTap()
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Empty State
struct EmptyPlacesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "location.slash")
                .font(.system(size: 24))
                .foregroundColor(.textSecondary)
            
            Text("Места не найдены")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.textPrimary)
            
            Text("Попробуйте изменить фильтры или поискать в другом месте")
                .font(.system(size: 14))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
}
