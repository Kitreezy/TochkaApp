import Foundation
import CoreLocation

public struct Activity: Codable, Identifiable {
    public let id: String
    public let title: String
    public let description: String
    public let category: ActivityCategory
    public let location: ActivityLocation
    public let dateTime: Date
    public let creatorId: String
    public let maxParticipants: Int?
    public let participantIds: [String] // User IDs
    public let isActive: Bool
    public let createdAt: Date
    public let updatedAt: Date

    public init(id: String = UUID().uuidString,
                title: String,
                description: String,
                category: ActivityCategory,
                location: ActivityLocation,
                dateTime: Date,
                creatorId: String,
                maxParticipants: Int? = nil,
                participantIds: [String] = [],
                isActive: Bool = true,
                createdAt: Date = Date(),
                updatedAt: Date)
    {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.location = location
        self.dateTime = dateTime
        self.creatorId = creatorId
        self.maxParticipants = maxParticipants
        self.participantIds = participantIds
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public var iscREATOR: Bool {
        false
    }
    
    public var hasSpaceLeft: Bool {
        guard let maxParticipants = maxParticipants else {
            return true 
        }
        return participantIds.count < maxParticipants
    }
}
