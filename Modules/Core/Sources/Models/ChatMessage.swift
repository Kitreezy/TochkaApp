import Foundation

public struct ChatMessage: Codable, Identifiable {
    public let id: String
    public let activityId: String
    public let senderId: String
    public let senderNickname: String
    public let content: String
    public let timestamp: Date
    public let type: MessageType
    
    public enum MessageType: String, Codable {
        case text = "text"
        case image = "image"
        case system = "system"
    }
    
    public init(id: String = UUID().uuidString,
                activityId: String,
                senderId: String,
                senderNickname: String,
                content: String,
                timestamp: Date = Date(),
                type: MessageType = .text
    ) {
        self.id = id
        self.activityId = activityId
        self.senderId = senderId
        self.senderNickname = senderNickname
        self.content = content
        self.timestamp = timestamp
        self.type = type
    }
}
