import SwiftUI
import Core
import DesignSystem

public struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    let onGetStarted: () -> Void
    let onSkip: () -> Void
    
    public init(onGetStarted: @escaping () -> Void, onSkip: @escaping () -> Void) {
        self.onGetStarted = onGetStarted
        self.onSkip = onSkip
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.accentGreen
                    .ignoresSafeArea()
                
                DecorativeElements.authElements
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer(minLength: 80)
                        
                        VStack(spacing: 32) {
                            ShimmerLogo(size: 120)
                            
                            VStack(spacing: 16) {
                                Text("Tochka")
                                    .font(.system(size: 36, weight: .bold, design: .default))
                                    .foregroundColor(.black)
                                    .tracking(-1)
                                
                                Text("Откройте удивительные места рядом с вами и исследуйте мир")
                                    .font(.system(size: 18))
                                    .foregroundColor(.black.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                    .padding(.horizontal, 32)
                                    .lineSpacing(4)
                            }
                        }
                        
                        Spacer(minLength: 48)
                        
                        VStack(spacing: 24) {
                            FeatureRow(
                                icon: "🗺️",
                                title: "Откройте новые места",
                                subtitle: "Находите скрытые жемчужины поблизости",
                                gradient: AppGradients.pink,
                                isVisible: $viewModel.feature1Visible
                            )
                            
                            FeatureRow(
                                icon: "🌟",
                                title: "Делитесь впечатлениями",
                                subtitle: "Оценивайте места и оставляйте отзывы",
                                gradient: AppGradients.green,
                                isVisible: $viewModel.feature2Visible
                            )
                            
                            FeatureRow(
                                icon: "🎯",
                                title: "Персональные маршруты",
                                subtitle: "Создавайте уникальные путешествия",
                                gradient: AppGradients.purple,
                                isVisible: $viewModel.feature3Visible
                            )
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 48)
                        
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(index == viewModel.currentPage ? Color.black : Color.black.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(index == viewModel.currentPage ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)
                            }
                        }
                        .padding(.bottom, 32)
                        
                        VStack(spacing: 16) {
                            Button(action: onGetStarted) {
                                Text("Начать исследование")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(AppGradients.appleBlue)
                                    )
                                    .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .scaleEffect(viewModel.buttonsVisible ? 1.0 : 0.8)
                            .opacity(viewModel.buttonsVisible ? 1.0 : 0.0)
                            
                            Button(action: onSkip) {
                                Text("Пропустить")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black.opacity(0.6))
                                    .frame(height: 44)
                            }
                            .opacity(viewModel.buttonsVisible ? 1.0 : 0.0)
                        }
                        .padding(.horizontal, 32)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(1.0), value: viewModel.buttonsVisible)
                        
                        Spacer(minLength: 80)
                    }
                }
            }
        }
        .onAppear {
            viewModel.startAnimations()
        }
    }
}
