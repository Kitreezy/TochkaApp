import SwiftUI
import Core
import DesignSystem 

public struct RegistrationView: View {
    @StateObject private var viewModel = AuthViewModel()
    let onSwitchToLogin: () -> Void
    let onBack: () -> Void
    
    public init(
        onSwitchToLogin: @escaping () -> Void,
        onBack: @escaping () -> Void
    ) {
        self.onSwitchToLogin = onSwitchToLogin
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
            VStack(spacing: 24) {
                Spacer(minLength: 10)
                
                headrerSection
                formSection
                dividerSection
                footerSection
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 32)
        }
    }
    
    // MARK: - Header Section
    private var headrerSection: some View {
        VStack(spacing: 16) {
            Text("Создать аккаунт")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.black)
            
            Text("Присоединяйтесь к сообществу Tochka")
                .font(.system(size: 16))
                .foregroundColor(.black.opacity(0.7))
        }
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 20) {
            nameField
            emailField
            passwordField
            checkboxSection
            
            AuthButton(title: "Создать аккаунт",
                       isLoading: viewModel.isLoading,
                       isEnabled: viewModel.isRegistrationFormValid,
                       style: .primary
            ) {
                viewModel.signUp()
            }
        }
    }
    
    private var nameField: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Имя")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
                
                TextField("Артем", text: $viewModel.firstName)
                    .modernTextFieldStyle(.auth)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Фамилия")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
                
                TextField("Артемов", text: $viewModel.lastName)
                    .modernTextFieldStyle(.auth)
            }
        }
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)
            
            TextField("your@email.com", text: $viewModel.email)
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
                    TextField("Минимум 8 символов", text: $viewModel.password)
                } else {
                    SecureField("Минимум 8 символов", text: $viewModel.password)
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
    
    // MARK: - Checkbox Section
    private var checkboxSection: some View {
        VStack(spacing: 12) {
            CheckboxWithAttributedText(
                isChecked: $viewModel.agreeToTerms,
                attributedText: Text("Я соглашаюсь с ")
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.7))
                + Text("Условиями использования")
                    .font(.system(size: 14))
                    .foregroundColor(.primaryBlue)
                + Text(" и ")
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.7))
                + Text("Политикой конфиденциальности")
                    .font(.system(size: 14))
                    .foregroundColor(.primaryBlue)
            )
            
            CheckboxWithText(
                isChecked: $viewModel.subscribeToNotifications,
                text: "Получать уведомления о новых местах поблизости"
            )
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
                .foregroundColor(.black.opacity(0.6))
                .padding(.horizontal, 16)
            
            Rectangle()
                .fill(Color.black.opacity(0.2))
                .frame(height: 1)
        }
    }
    
    // MARK: - Footer Section
    private var footerSection: some View {
        HStack {
            Text("Уже есть аккаунт?")
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.7))
            
            Button("Войти") {
                onSwitchToLogin()
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.primaryBlue)
        }
    }
}
