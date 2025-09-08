//
//  ContentView.swift
//  Tochka
//
//  Created by Artem Rodionov on 08.07.2025.
//

import SwiftUI
import Core
import AuthFeature

public struct ContentView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var isInitialLoad = true
    
    public init() {}

    public var body: some View {
        Group {
            if isInitialLoad {
                SplashView()
            } else if authManager.isAuthenticated {
                MainTabView()
                    .environmentObject(authManager)
            } else {
                AuthenticationView()
                    .environmentObject(authManager)
            }
        }
        .onAppear {
            checkInitialState()
        }
        .onChange(of: authManager.isAuthenticated) { _ in
            // Когда состояние авторизации меняется, убираем загрузку
            if isInitialLoad {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isInitialLoad = false
                    }
                }
            }
        }
    }
    
    private func checkInitialState() {
        authManager.checkAuthenticationStatus()
        
        // Даем время Firebase проверить состояние
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isInitialLoad = false
            }
        }
    }
}

// MARK: - Splash View (простой экран загрузки)
struct SplashView: View {
    var body: some View {
        ZStack {
            Color.accentGreen
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Логотип
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppGradients.appleBlue)
                        .frame(width: 100, height: 100)
                        .shadow(color: Color.blue.opacity(0.3), radius: 20, x: 0, y: 8)
                    
                    if let _ = UIImage(named: "tochka-logo") {
                        Image("tochka-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                    } else {
                        Image(systemName: "location.fill")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                
                Text("Tochka")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(1.2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
