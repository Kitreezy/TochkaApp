//
//  Place.swift
//  MapFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import Core

public struct Place: Identifiable, Codable {
    public let id: String
    public let name: String
    public let description: String
    public let category: PlaceCategory
    public let coordinate: CLLocationCoordinate2D
    public let address: String
    public let rating: Double
    public let reviewCount: Int
    public let priceLevel: PriceLevel? // $ $$ $$$
    public let openingHours: String?
    public let phoneNumber: String?
    public let website: String?
    public let imageURL: String?
    
    public enum PriceLevel: String, CaseIterable, Codable {
        case budget = "$"
        case moderate = "$$"
        case expensive = "$$$"
        case luxury = "$$$$"
        
        public var displayName: String {
            switch self {
            case .budget: return "Бюджетно"
            case .moderate: return "Умеренно"
            case .expensive: return "Дорого"
            case .luxury: return "Премиум"
            }
        }
    }
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String,
        category: PlaceCategory,
        coordinate: CLLocationCoordinate2D,
        address: String,
        rating: Double = 0.0,
        reviewCount: Int = 0,
        priceLevel: PriceLevel? = nil,
        openingHours: String? = nil,
        phoneNumber: String? = nil,
        website: String? = nil,
        imageURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.coordinate = coordinate
        self.address = address
        self.rating = rating
        self.reviewCount = reviewCount
        self.priceLevel = priceLevel
        self.openingHours = openingHours
        self.phoneNumber = phoneNumber
        self.website = website
        self.imageURL = imageURL
    }
    
    // MARK: - Computed Properties
    
    public var ratingDisplay: String {
        String(format: "%.1f", rating)
    }
    
    public var reviewCountDisplay: String {
        if reviewCount < 1000 {
            return "\(reviewCount) отзывов"
        } else {
            return "\(reviewCount / 1000)k отзывов"
        }
    }
    
    public func distance(from userLocation: CLLocationCoordinate2D) -> CLLocationDistance {
        return coordinate.distance(to: userLocation)
    }
    
    public func distanceDisplay(from userLocation: CLLocationCoordinate2D) -> String {
        return coordinate.distanceDisplay(to: userLocation)
    }
}

// MARK: - Пример данных для тестирования
public extension Place {
    static let samplePlaces: [Place] = [
        Place(
            name: "City Museum",
            description: "Historical artifacts and exhibitions",
            category: .culture,
            coordinate: CLLocationCoordinate2D(latitude: 59.3293, longitude: 18.0686),
            address: "Gamla Stan 1, Stockholm",
            rating: 4.8,
            reviewCount: 234,
            priceLevel: .moderate,
            openingHours: "9:00 - 18:00"
        ),
        Place(
            name: "Central Park",
            description: "Beautiful green space in the heart of the city",
            category: .nature,
            coordinate: CLLocationCoordinate2D(latitude: 59.3326, longitude: 18.0649),
            address: "Kungsträdgården, Stockholm",
            rating: 4.9,
            reviewCount: 156,
            openingHours: "24/7"
        ),
        Place(
            name: "Cozy Cafe",
            description: "Artisan coffee and fresh pastries",
            category: .food,
            coordinate: CLLocationCoordinate2D(latitude: 59.3341, longitude: 18.0630),
            address: "Drottninggatan 45, Stockholm",
            rating: 4.7,
            reviewCount: 89,
            priceLevel: .budget,
            openingHours: "7:00 - 19:00"
        ),
        Place(
            name: "Art Gallery",
            description: "Contemporary art and local artists",
            category: .culture,
            coordinate: CLLocationCoordinate2D(latitude: 59.3365, longitude: 18.0710),
            address: "Södermalm 12, Stockholm",
            rating: 4.6,
            reviewCount: 67,
            priceLevel: .moderate,
            openingHours: "10:00 - 20:00"
        ),
        Place(
            name: "Shopping Mall",
            description: "Modern shopping center with various stores",
            category: .shopping,
            coordinate: CLLocationCoordinate2D(latitude: 59.3311, longitude: 18.0581),
            address: "Sergels Torg 2, Stockholm",
            rating: 4.3,
            reviewCount: 445,
            openingHours: "10:00 - 21:00"
        )
    ]
}
