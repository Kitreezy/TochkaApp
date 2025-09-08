import SwiftUI
import Core
import DesignSystem

public struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    let onSwitchToRegistration: () -> Void
    let onBack: () -> Void
    
    public init(
        onSwitchToRegistration: @escaping () -> Void,
        onBack: @escaping () -> Void
    ) {
        self.onSwitchToRegistration = onSwitchToRegistration
        self.onBack = onBack
    }
    
    public var body: some View {
        CustomNavigationHeader.auth(
              title: "",
              onBack: onBack
          ) {
              ZStack {
                  backgroundView
                  mainContent
              }
          }
          .alert("Ошибка", isPresented: $viewModel.showError) {
              Button("ОК") { viewModel.clearError() }
          } message: {
              Text(viewModel.errorMessage ?? "Неизвестная ошибка")
          }
          .alert("Сброс пароля", isPresented: $viewModel.showPasswordResetAlert) {
              Button("ОК") {}
          } message: {
              Text("Инструкции по сбросу пароля отправлены на ваш email")
          }
    }
    
    // MARK: - Background
    private var backgroundView: some View {
        ZStack {
            Color.accentGreen
                .ignoresSafeArea()
            
            DecorativeElements.authElements
        }
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer(minLength: 10)
                
                headerSection
                formSection
                dividerSection
                socialButtonsSection
                footerSection
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 32)
        }
        .scrollIndicators(.never)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Добро пожаловать")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.black)
            
            Text("Войдите в свой аккаунт")
                .font(.system(size: 16))
                .foregroundStyle(.black.opacity(0.7))
        }
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 24) {
            emailField
            passwordField
            forgotPasswordLink
            
            AuthButton(title: "Войти",
                       isLoading: viewModel.isLoading,
                       isEnabled: viewModel.isLoginFormValid,
                       style: .primary
            ) {
                viewModel.signIn()
            }
        }
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)
            
            TextField("Введите email", text: $viewModel.email)
                .modernTextFieldStyle(.auth)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled(true)
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Пароль")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)
            
            HStack {
                if viewModel.showPassword {
                    TextField("Ввeдите пароль", text: $viewModel.password)
                } else {
                    SecureField("Ввeдите пароль", text: $viewModel.password)
                }
                
                Button(action: { viewModel.showPassword.toggle() }) {
                    Text(viewModel.showPassword ? "Скрыть" : "Показать")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.black.opacity(0.6))
                }
            }
            .modernTextFieldStyle(.auth)
        }
    }
    
    private var forgotPasswordLink: some View {
        HStack {
            Spacer()
            Button("Забыл пароль") {
                viewModel.resetPassword()
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(Color.primaryBlue)
        }
    }
    
    // MARK: - Divider Section
    private var dividerSection: some View {
        HStack {
            Rectangle()
                .fill(Color.black.opacity(0.2))
                .frame(height: 1)
            
            Text("или")
                .font(.system(size: 14))
                .foregroundStyle(.black.opacity(0.6))
                .padding(.horizontal, 16)
            
            Rectangle()
                .fill(Color.black.opacity(0.6))
                .frame(height: 1)
        }
    }
    
    // MARK: - Social Buttons Section
    private var socialButtonsSection: some View {
        VStack(spacing: 12) {
            AuthButton.apple(
                title: "Войти через Apple",
                isLoading: viewModel.isAppleLoading
            ) {
                viewModel.signInWithApple()
            }
            
            AuthButton.google(
                title: "Войти через Google",
                isLoading: viewModel.isGoogleLoading
            ) {
                viewModel.signInWithGoogle()
            }
        }
    }
    
    // MARK: - Footer Section
    private var footerSection: some View {
        HStack {
            Text("Нет аккаунта?")
                .font(.system(size: 14))
                .foregroundStyle(.black.opacity(0.7))
            
            Button("Зарегистрироваться") {
                onSwitchToRegistration()
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(Color.primaryBlue)
        }
    }
}
