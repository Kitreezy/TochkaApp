//
//  UIKitWrappers.swift
//  MapFeature
//
//  Created by Artem Rodionov on 22.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import UIKit
import Core
import CoreLocation

// MARK: - SimpleBottomSheetView (SwiftUI Wrapper)
public struct BottomSheetView: UIViewControllerRepresentable {
    let places: [Place]
    let userLocation: CLLocationCoordinate2D?
    @Binding var selectedPlace: Place?
    let onPlaceSelected: (Place) -> Void
    let onCreateActivity: (Place) -> Void
    
    public init(
        places: [Place],
        userLocation: CLLocationCoordinate2D?,
        selectedPlace: Binding<Place?>,
        onPlaceSelected: @escaping (Place) -> Void,
        onCreateActivity: @escaping (Place) -> Void
    ) {
        self.places = places
        self.userLocation = userLocation
        self._selectedPlace = selectedPlace
        self.onPlaceSelected = onPlaceSelected
        self.onCreateActivity = onCreateActivity
    }
    
    public func makeUIViewController(context: Context) -> BottomSheetViewController {
        let controller = BottomSheetViewController()
        
        // Безопасно устанавливаем callbacks
        controller.onPlaceSelected = { [weak controller] place in
            DispatchQueue.main.async {
                self.onPlaceSelected(place)
            }
        }
        
        controller.onCreateActivity = { [weak controller] place in
            DispatchQueue.main.async {
                self.onCreateActivity(place)
            }
        }
        
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: BottomSheetViewController, context: Context) {
        // Безопасно обновляем данные
        if uiViewController.places != places {
            uiViewController.places = places
        }
        
        uiViewController.userLocation = userLocation
        uiViewController.selectedPlace = selectedPlace
    }
}

// MARK: - SimpleCategoryFilterView (SwiftUI Wrapper)
public struct SimpleCategoryFilterView: UIViewControllerRepresentable {
    @Binding var selectedCategory: PlaceCategory
    let onCategoryChanged: (PlaceCategory) -> Void
    
    public init(
        selectedCategory: Binding<PlaceCategory>,
        onCategoryChanged: @escaping (PlaceCategory) -> Void
    ) {
        self._selectedCategory = selectedCategory
        self.onCategoryChanged = onCategoryChanged
    }
    
    public func makeUIViewController(context: Context) -> CategoryFilterViewController {
        let controller = CategoryFilterViewController()
        
        // Безопасно устанавливаем callback
        controller.onCategoryChanged = { [weak controller] category in
            DispatchQueue.main.async {
                self.selectedCategory = category
                self.onCategoryChanged(category)
            }
        }
        
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: CategoryFilterViewController, context: Context) {
        // Безопасно проверяем изменения
        let currentCategory = uiViewController.getCurrentSelectedCategory()
        if currentCategory != selectedCategory {
            uiViewController.selectCategory(selectedCategory)
        }
    }
}

// MARK: - Convenience extensions for safer usage
extension BottomSheetView {
    
    /// Создает bottom sheet с пустым состоянием по умолчанию
    public static func empty(
        selectedPlace: Binding<Place?> = .constant(nil),
        onPlaceSelected: @escaping (Place) -> Void = { _ in },
        onCreateActivity: @escaping (Place) -> Void = { _ in }
    ) -> BottomSheetView {
        return BottomSheetView(
            places: [],
            userLocation: nil,
            selectedPlace: selectedPlace,
            onPlaceSelected: onPlaceSelected,
            onCreateActivity: onCreateActivity
        )
    }
}

extension SimpleCategoryFilterView {
    
    /// Создает category filter с базовой конфигурацией
    public static func basic(
        selectedCategory: Binding<PlaceCategory> = .constant(.all),
        onCategoryChanged: @escaping (PlaceCategory) -> Void = { _ in }
    ) -> SimpleCategoryFilterView {
        return SimpleCategoryFilterView(
            selectedCategory: selectedCategory,
            onCategoryChanged: onCategoryChanged
        )
    }
}
