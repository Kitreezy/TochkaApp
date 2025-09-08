//
//  AppCoordinator.swift
//  Tochka
//
//  Created by Artem Rodionov on 08.07.2025.
//

import Core
import SwiftUI

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
