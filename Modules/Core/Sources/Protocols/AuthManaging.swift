import Foundation
import Combine

public protocol AuthManaging: AnyObject {
    // Publishers for state observation
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorMessagePublisher: AnyPublisher<String?, Never> { get }

    // Actions
    func signIn(email: String, password: String)
    func signUp(email: String, password: String)
    func clearError()
}


