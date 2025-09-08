import Foundation
import Combine
import Core

@MainActor
public class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var isRegistering = false
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var showPasswordResetAlert = false
    @Published var agreeToTerms = false
    @Published var subscribeToNotifications = true
    @Published var showPassword = false
    @Published var isAppleLoading = false
    @Published var isGoogleLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let authManager: AuthManaging
    
    public init(authManager: AuthManaging = AuthManager.shared) {
        self.authManager = authManager
        // Подписываемся на состояние AuthManager
        authManager.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        authManager.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.errorMessage = error
                    self?.showError = true
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Form Validation
    
    var isLoginFormValid: Bool {
        !email.isEmpty &&
        email.validEmail &&
        !password.isEmpty &&
        password.count >= 6
    }
    
    var isRegistrationFormValid: Bool {
        !email.isEmpty &&
        email.validEmail &&
        !password.isEmpty &&
        password.count >= 6 &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        agreeToTerms
    }
    
    // MARK: - Actions
    
    func signIn() {
        guard isLoginFormValid else { return }
        
        clearError()
        authManager.signIn(email: email, password: password)
    }
    
    func signUp() {
        guard isRegistrationFormValid else { return }
        
        clearError()
        authManager.signUp(email: email, password: password)
    }
    
    func resetPassword() {
        guard !email.isEmpty, email.validEmail else {
            showErrorMessage("Введите корректный email для сброса пароля")
            return
        }
        
        showPasswordResetAlert = true
    }
    
    // MARK: - Social Authentication (заглушки для будущей реализации)
    
    func signInWithApple() {
        isAppleLoading = true
        
        // TODO: Implement Apple Sign In
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.isAppleLoading = false
            self?.showErrorMessage("Apple Sign In будет реализован позже")
        }
    }
    
    func signInWithGoogle() {
        isGoogleLoading = true
        
        // TODO: Implement Google Sign In
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.isGoogleLoading = false
            self?.showErrorMessage("Google Sign In будет реализован позже")
        }
    }
    
    func clearError() {
        showError = false
        errorMessage = nil
        authManager.clearError()
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}
