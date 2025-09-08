//
//  ActivityCategory.swift
//  Core
//
//  Created by Artem Rodionov on 14.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import Foundation

public enum ActivityCategory: String, CaseIterable, Codable {
    case meeting = "meeting"
    case concert = "concert"
    case boardGames = "board_games"
    case sport = "sport"
    case food = "food"
    case culture = "culture"
    case other = "other"

    public var displayName: String {
        switch self {
        case .meeting: return "Встреча"
        case .concert: return "Концерт"
        case .boardGames: return "Настольные игры"
        case .sport: return "Спорт"
        case .food: return "Еда"
        case .culture: return "Культура"
        case .other: return "Другое"
        }
    }

    public var emoji: String {
        switch self {
        case .meeting: return "🤝"
        case .concert: return "🎵"
        case .boardGames: return "🎲"
        case .sport: return "⚽️"
        case .food: return "🍕"
        case .culture: return "🎭"
        case .other: return "📍"
        }
    }
}
