//
//  Place + Equatable.swift
//  MapFeature
//
//  Created by Artem Rodionov on 22.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - Place Equatable Extension
extension Place: Equatable {
    public static func == (lhs: Place, rhs: Place) -> Bool {
        // Сравниваем по уникальному идентификатору для быстродействия
        return lhs.id == rhs.id
    }
}

// MARK: - PlaceCategory Equatable 
extension PlaceCategory: Equatable {
    public static func == (lhs: PlaceCategory, rhs: PlaceCategory) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

// MARK: - Place.PriceLevel Equatable
extension Place.PriceLevel: Equatable {
    public static func == (lhs: Place.PriceLevel, rhs: Place.PriceLevel) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
