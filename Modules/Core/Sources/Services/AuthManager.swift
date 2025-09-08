//
// AuthManager.swift
// Core
//

import Foundation
import Combine
import FirebaseAuth
import Core

public class AuthManager: ObservableObject {
    public static let shared = AuthManager()
    
    @Published public var isAuthenticated = false
    @Published public var currentUser: FirebaseAuth.User?
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    private init() {
        // Слушаем изменения авторизации
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    public func checkAuthenticationStatus() {
        currentUser = Auth.auth().currentUser
        isAuthenticated = currentUser != nil
    }
    
    public func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.currentUser = result?.user
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    public func signUp(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.currentUser = result?.user
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    public func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            isAuthenticated = false
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    public func clearError() {
        errorMessage = nil
    }
}

extension AuthManager: AuthManaging {
    public var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    public var errorMessagePublisher: AnyPublisher<String?, Never> {
        $errorMessage.eraseToAnyPublisher()
    }
}
