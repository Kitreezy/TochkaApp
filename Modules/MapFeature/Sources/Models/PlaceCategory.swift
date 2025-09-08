//
//  PlaceCategory.swift
//  MapFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import Foundation
import SwiftUI
import Core

public enum PlaceCategory: String, CaseIterable, Codable {
    case all = "all"
    case food = "food"
    case culture = "culture"
    case nature = "nature"
    case shopping = "shopping"
    case entertainment = "entertainment"
    case accommodation = "accommodation"
    case transport = "transport"
    
    public var displayName: String {
        switch self {
        case .all: return "Все"
        case .food: return "Еда"
        case .culture: return "Культура"
        case .nature: return "Природа"
        case .shopping: return "Покупки"
        case .entertainment: return "Развлечения"
        case .accommodation: return "Жилье"
        case .transport: return "Транспорт"
        }
    }
    
    public var emoji: String {
        switch self {
        case .all: return "🌍"
        case .food: return "🍽️"
        case .culture: return "🏛️"
        case .nature: return "🌳"
        case .shopping: return "🏪"
        case .entertainment: return "🎪"
        case .accommodation: return "🏨"
        case .transport: return "🚇"
        }
    }
    
    public var gradient: LinearGradient {
        switch self {
        case .all:
            return AppGradients.appleBlue
        case .food:
            return AppGradients.orange
        case .culture:
            return AppGradients.purple
        case .nature:
            return AppGradients.green
        case .shopping:
            return AppGradients.pink
        case .entertainment:
            return AppGradients.blue
        case .accommodation:
            return LinearGradient(
                colors: [Color.purple, Color.pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .transport:
            return LinearGradient(
                colors: [Color.gray, Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    public var iconSystemName: String {
        switch self {
        case .all: return "globe"
        case .food: return "fork.knife"
        case .culture: return "building.columns"
        case .nature: return "tree"
        case .shopping: return "bag"
        case .entertainment: return "theatermasks"
        case .accommodation: return "bed.double"
        case .transport: return "train.side.front.car"
        }
    }
}
