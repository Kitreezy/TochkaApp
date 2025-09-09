import XCTest
import Combine
@testable import AuthFeature
import Core

final class MockAuthManager: AuthManaging {
    let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    let errorMessageSubject = CurrentValueSubject<String?, Never>(nil)

    var isLoadingPublisher: AnyPublisher<Bool, Never> { isLoadingSubject.eraseToAnyPublisher() }
    var errorMessagePublisher: AnyPublisher<String?, Never> { errorMessageSubject.eraseToAnyPublisher() }

    private(set) var signInCalls: [(email: String, password: String)] = []
    private(set) var signUpCalls: [(email: String, password: String)] = []

    func signIn(email: String, password: String) {
        signInCalls.append((email, password))
    }

    func signUp(email: String, password: String) {
        signUpCalls.append((email, password))
    }

    func clearError() {
        errorMessageSubject.send(nil)
    }
}

final class AuthViewModelTests: XCTestCase {
    @MainActor func test_loginFormValidation_validData_returnsTrue() {
        let vm = AuthViewModel(authManager: MockAuthManager())
        vm.email = "user@example.com"
        vm.password = "123456"
        XCTAssertTrue(vm.isLoginFormValid)
    }

    @MainActor func test_loginFormValidation_invalidEmail_returnsFalse() {
        let vm = AuthViewModel(authManager: MockAuthManager())
        vm.email = "invalid"
        vm.password = "123456"
        XCTAssertFalse(vm.isLoginFormValid)
    }

    @MainActor func test_registrationFormValidation_requiresMatchingPasswordsAndTerms() {
        let vm = AuthViewModel(authManager: MockAuthManager())
        vm.email = "user@example.com"
        vm.password = "123456"
        vm.confirmPassword = "123456"
        vm.agreeToTerms = true
        XCTAssertTrue(vm.isRegistrationFormValid)
    }

    @MainActor func test_signIn_invokesManagerWhenFormValid() {
        let mock = MockAuthManager()
        let vm = AuthViewModel(authManager: mock)
        vm.email = "user@example.com"
        vm.password = "123456"
        vm.signIn()
        XCTAssertEqual(mock.signInCalls.count, 1)
        XCTAssertEqual(mock.signInCalls.first?.email, "user@example.com")
    }

    @MainActor func test_signIn_doesNotInvokeManagerWhenFormInvalid() {
        let mock = MockAuthManager()
        let vm = AuthViewModel(authManager: mock)
        vm.email = "invalid"
        vm.password = "123456"
        vm.signIn()
        XCTAssertEqual(mock.signInCalls.count, 0)
    }

    @MainActor func test_signUp_invokesManagerWhenFormValid() {
        let mock = MockAuthManager()
        let vm = AuthViewModel(authManager: mock)
        vm.email = "user@example.com"
        vm.password = "123456"
        vm.confirmPassword = "123456"
        vm.agreeToTerms = true
        vm.signUp()
        XCTAssertEqual(mock.signUpCalls.count, 1)
    }

    @MainActor func test_signUp_doesNotInvokeManagerWhenFormInvalid() {
        let mock = MockAuthManager()
        let vm = AuthViewModel(authManager: mock)
        vm.email = "user@example.com"
        vm.password = "123456"
        vm.confirmPassword = "mismatch"
        vm.agreeToTerms = false
        vm.signUp()
        XCTAssertEqual(mock.signUpCalls.count, 0)
    }

    @MainActor func test_resetPassword_withInvalidEmail_setsError() {
        let vm = AuthViewModel(authManager: MockAuthManager())
        vm.email = "invalid"
        vm.resetPassword()
        XCTAssertTrue(vm.showError)
        XCTAssertNotNil(vm.errorMessage)
    }

    @MainActor func test_clearError_resetsFlagsAndDelegatesToManager() {
        let mock = MockAuthManager()
        let vm = AuthViewModel(authManager: mock)
        vm.errorMessage = "Some error"
        vm.showError = true
        vm.clearError()
        XCTAssertFalse(vm.showError)
        XCTAssertNil(vm.errorMessage)
    }
}


