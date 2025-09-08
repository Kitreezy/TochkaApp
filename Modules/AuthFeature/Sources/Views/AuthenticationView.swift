import SwiftUI
import Core
import DesignSystem

public struct AuthenticationView: View {
    @State private var currentScreen: AuthScreen = .welcome
    
    public init() {}
    
    public var body: some View {
        // Один общий фон для всех экранов - убираем белые промежутки
        ZStack {
            // Постоянный зеленый фон
            Color.accentGreen
                .ignoresSafeArea()
            
            // Контент с плавными переходами
            Group {
                switch currentScreen {
                case .welcome:
                    WelcomeView(
                        onGetStarted: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                currentScreen = .login
                            }
                        },
                        onSkip: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                currentScreen = .login
                            }
                        }
                    )
                    
                case .login:
                    LoginView(
                        onSwitchToRegistration: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentScreen = .registration
                            }
                        },
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                currentScreen = .welcome
                            }
                        }
                    )
                    
                case .registration:
                    RegistrationView(
                        onSwitchToLogin: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentScreen = .login
                            }
                        },
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentScreen = .login
                            }
                        }
                    )
                }
            }
            .transition(.opacity)
        }
    }
}

// MARK: - Auth Screen Enum
enum AuthScreen {
    case welcome
    case login
    case registration
}
