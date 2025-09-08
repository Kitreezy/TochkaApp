//
//  PlacesService.swift
//  MapFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import Foundation
import MapKit
import Combine
import CoreLocation

public class PlacesService: ObservableObject {
    public static let shared = PlacesService()
    
    @Published public var places: [Place] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    private let geocoder = CLGeocoder()
    private var searchTask: Task<Void, Never>?
    
    private init() {
        // Загружаем тестовые данные для начала
        loadSamplePlaces()
    }
    
    // MARK: - Public Methods
    
    public func searchPlaces(
        query: String,
        category: PlaceCategory = .all,
        around location: CLLocationCoordinate2D,
        radius: CLLocationDistance = 5000
    ) {
        // Отменяем предыдущий поиск
        searchTask?.cancel()
        
        searchTask = Task { @MainActor in
            await performSearch(
                query: query,
                category: category,
                around: location,
                radius: radius
            )
        }
    }
    
    public func getPlacesNearby(
        location: CLLocationCoordinate2D,
        category: PlaceCategory = .all,
        radius: CLLocationDistance = 5000
    ) {
        searchTask?.cancel()
        
        searchTask = Task { @MainActor in
            await loadNearbyPlaces(
                around: location,
                category: category,
                radius: radius
            )
        }
    }
    
    public func filterPlaces(by category: PlaceCategory) {
        if category == .all {
            // Показываем все места
            return
        }
        
        places = places.filter { $0.category == category }
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func performSearch(
        query: String,
        category: PlaceCategory,
        around location: CLLocationCoordinate2D,
        radius: CLLocationDistance
    ) async {
        print("🔍 PlacesService: Поиск '\(query)' в категории \(category.displayName)")
        
        isLoading = true
        errorMessage = nil
        
        do {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.region = MKCoordinateRegion(
                center: location,
                latitudinalMeters: radius * 2,
                longitudinalMeters: radius * 2
            )
            
            let search = MKLocalSearch(request: request)
            let response = try await search.start()
            
            let foundPlaces = response.mapItems.compactMap { mapItem -> Place? in
                guard let placemark = mapItem.placemark.location?.coordinate else { return nil }
                
                return Place(
                    name: mapItem.name ?? "Неизвестное место",
                    description: mapItem.placemark.areasOfInterest?.first ?? "Интересное место",
                    category: detectCategory(from: mapItem),
                    coordinate: placemark,
                    address: formatAddress(from: mapItem.placemark),
                    rating: Double.random(in: 3.5...5.0), // Пока рандомный рейтинг
                    reviewCount: Int.random(in: 10...500),
                    openingHours: "9:00 - 18:00" // Пока статичные часы
                )
            }
            
            // Фильтруем по категории если нужно
            if category == .all {
                places = foundPlaces
            } else {
                places = foundPlaces.filter { $0.category == category }
            }
            
            print("✅ PlacesService: Найдено \(places.count) мест")
            
        } catch {
            print("❌ PlacesService: Ошибка поиска: \(error.localizedDescription)")
            errorMessage = "Ошибка поиска: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    @MainActor
    private func loadNearbyPlaces(
        around location: CLLocationCoordinate2D,
        category: PlaceCategory,
        radius: CLLocationDistance
    ) async {
        print("📍 PlacesService: Загружаем места рядом с \(location)")
        
        // Пока используем тестовые данные + поиск популярных мест
        await performSearch(
            query: category == .all ? "достопримечательности" : category.displayName,
            category: category,
            around: location,
            radius: radius
        )
    }
    
    private func loadSamplePlaces() {
        places = Place.samplePlaces
        print("📍 PlacesService: Загружены тестовые места: \(places.count)")
    }
    
    private func detectCategory(from mapItem: MKMapItem) -> PlaceCategory {
        // Простая логика определения категории по pointOfInterestCategory
        switch mapItem.pointOfInterestCategory {
        case .restaurant, .bakery, .brewery, .cafe:
            return .food
        case .museum, .library, .theater:
            return .culture
        case .park, .nationalPark, .beach:
            return .nature
        case .store, .gasStation:
            return .shopping
        case .amusementPark, .movieTheater:
            return .entertainment
        case .hotel:
            return .accommodation
        case .publicTransport, .airport:
            return .transport
        default:
            return .all
        }
    }
    
    private func formatAddress(from placemark: CLPlacemark) -> String {
        var addressComponents: [String] = []
        
        if let thoroughfare = placemark.thoroughfare {
            addressComponents.append(thoroughfare)
        }
        
        if let subThoroughfare = placemark.subThoroughfare {
            addressComponents.append(subThoroughfare)
        }
        
        if let locality = placemark.locality {
            addressComponents.append(locality)
        }
        
        return addressComponents.joined(separator: ", ")
    }
}

