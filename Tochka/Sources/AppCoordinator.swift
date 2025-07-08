import SwiftUI
import Core

@MainActor
class AppCoordinator: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    func checkAuthenticationStatus() {
        isAuthenticated = false
    }
    
    func signIn(user: User) {
        currentUser = user
        isAuthenticated = true
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false 
    }
}
