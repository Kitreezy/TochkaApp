//
//  AuthenticationView.swift
//  Tochka
//
//  Created by Artem Rodionov on 11.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import Core

struct AuthenticationViewTest: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                    
                    // Logo Section
                    VStack(spacing: 16) {
                        Image(systemName: "location.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("Tochka")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                        Text("Находи интересные активности рядом с тобой")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Auth Form
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .keyboardType(.emailAddress)
                            
                            SecureField("Пароль", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        Button(action: {
                            authManager.clearError()
                            if isSignUp {
                                authManager.signUp(email: email, password: password)
                            } else {
                                authManager.signIn(email: email, password: password)
                            }
                        }) {
                            HStack {
                                if authManager.isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .foregroundColor(.white)
                                }
                                Text(isSignUp ? "Зарегистрироваться" : "Войти")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(email.isEmpty || password.isEmpty || authManager.isLoading)
                        
                        Button(action: {
                            isSignUp.toggle()
                            authManager.clearError()
                        }) {
                            Text(isSignUp ? "Уже есть аккаунт? Войти" : "Нет аккаунта? Зарегистрироваться")
                        }
                        .foregroundColor(.blue)
                        .disabled(authManager.isLoading)
                    }
                    .padding(.horizontal, 32)
                    
                    // Error Message
                    if let errorMessage = authManager.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .padding(.top, 8)
                    }
                    
                    Spacer()
                    
                    // Firebase Status
                    Text("🔥 Firebase интеграция")
                        .font(.caption2)
                        .foregroundColor(.orange)
                        .padding(.bottom, 32)
                }
            }
            .navigationTitle(isSignUp ? "Регистрация" : "Вход")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
