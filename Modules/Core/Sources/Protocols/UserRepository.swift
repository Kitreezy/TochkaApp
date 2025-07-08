import Foundation
import Combine

public protocol UserRepository {
    func getCurrentUser() -> AnyPublisher<User?, Error>
    func updateUser(_ user: User) -> AnyPublisher<Void, Error>
    func getUserById(_ id: Int) -> AnyPublisher<User?, Error>
}
