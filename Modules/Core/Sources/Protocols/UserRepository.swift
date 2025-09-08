import Combine
import Foundation

public protocol UserRepository {
    func getCurrentUser() -> AnyPublisher<User?, Error>
    func updateUser(_ user: User) -> AnyPublisher<Void, Error>
    func getUserById(_ id: String) -> AnyPublisher<Core.User?, any Error>
}
