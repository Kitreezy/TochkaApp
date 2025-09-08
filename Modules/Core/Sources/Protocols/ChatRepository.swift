import Combine
import Foundation

public protocol CChatRepository {
    func sendMessage(_ message: ChatMessage) -> AnyPublisher<Void, Error>
    func getMessages(for activityId: String) -> AnyPublisher<[ChatMessage], Error>
    func observeMessages(for activityId: String) -> AnyPublisher<ChatMessage, Error>
}
