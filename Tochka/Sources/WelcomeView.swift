import SwiftUI
import Core

struct WelcomeView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "location.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 16) {
                Text("Welcome to Tochka")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Находи интересные активности рядом с тобой")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: {
                    // TODO: Реализовать авторизацию
                    // Временно создаем тестового пользователя
                    let testUsesr = User(
                        id: "test-user",
                        email: "test@example.com",
                        nickname: "Test user"
                    )
                    coordinator.signIn(user: testUsesr)
                }) {
                    Text("Войти")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    // TODO: Реализовать регистрацию
                }) {
                    Text("Зарегистрироваться")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.clear)
                        .foregroundStyle(.blue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
        }
        .padding()
    }
}
