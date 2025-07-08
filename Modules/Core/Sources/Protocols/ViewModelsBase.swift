import SwiftUI
import Combine

@MainActor
open class BaseViewModel: ObservableObject {
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    public var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    public func showError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
    
    public func clearError() {
        errorMessage = nil
    }
}
