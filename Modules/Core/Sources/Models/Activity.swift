import Foundation

public struct Activity: Codable, Identifiable {
    public let id: String
    public let title: String
    public let description: String
    public let category: ActivityCategory
    public let location: ActivityLocation
    public let dateTime: Date
    public let creatorId: String
    public let maxParticipants: Int?
    public let currentParticipants: [String] // User IDs
    public let isActive: Bool
    public let createdAt: Date
    
    public init(id: String = UUID().uuidString,
                title: String,
                description: String,
                category: ActivityCategory,
                location: ActivityLocation,
                dateTime: Date,
                creatorId: String,
                maxParticipants: Int? = nil,
                currentParticipants: [String] = [],
                isActive: Bool = true,
                createdAt: Date = Date()
    ){
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.location = location
        self.dateTime = dateTime
        self.creatorId = creatorId
        self.maxParticipants = maxParticipants
        self.currentParticipants = currentParticipants
        self.isActive = isActive
        self.createdAt = createdAt
    }
}

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
