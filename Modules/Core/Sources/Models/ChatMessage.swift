import Foundation

public struct ChatMessage: Codable, Identifiable {
    public let id: String
    public let activityId: String
    public let senderId: String
    public let senderName: String
    public let text: String
    public let imageURL: String?
    public let timestamp: Date
    public let type: MessageType

    public enum MessageType: String, Codable {
        case text
        case image
        case system
    }

    public init(id: String = UUID().uuidString,
                activityId: String,
                senderId: String,
                senderName: String,
                text: String,
                imageURL: String? = nil,
                timestamp: Date = Date(),
                type: MessageType = .text)
    {
        self.id = id
        self.activityId = activityId
        self.senderId = senderId
        self.senderName = senderName
        self.text = text
        self.imageURL = imageURL
        self.timestamp = timestamp
        self.type = type
    }
}
