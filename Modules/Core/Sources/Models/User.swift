import Foundation

public struct User: Codable, Identifiable {
    public let id: String
    public let email: String
    public let nickname: String
    public let avatarUrl: String?
    public let createdAt: Date
    public let rating: Double
    
    public init(id: String,
                email: String,
                nickname: String,
                avatarUrl: String? = nil,
                createdAt: Date = Date(),
                rating: Double = 0.0
    ) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.avatarUrl = avatarUrl
        self.createdAt = createdAt
        self.rating = rating
    }
}
