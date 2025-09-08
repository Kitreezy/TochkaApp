import SwiftUI
import Combine

@MainActor
public class WelcomeViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var logoScale: CGFloat = 1.0
    @Published var floatingOffset: CGFloat = 0
    @Published var shimmerRotation: Double = 0
    @Published var feature1Visible = false
    @Published var feature2Visible = false
    @Published var feature3Visible = false
    @Published var buttonsVisible = false
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    func startAnimations() {
        // Логотип анимация
        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            logoScale = 1.1
        }
        
        // Shimmer эффект
        withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
            shimmerRotation = 360
        }
        
        // Плавающие элементы
        withAnimation(Animation.easeInOut(duration: 6).repeatForever()) {
            floatingOffset = 20
        }
        
        // Последовательное появление фич
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                self.feature1Visible = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                self.feature2Visible = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                self.feature3Visible = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                self.buttonsVisible = true
            }
        }
        
        // Автопереключение страниц
        Timer.publish(every: 3.0, on: .main, in: .common)
            .autoconnect()
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.currentPage = (self.currentPage + 1) % 3
                }
            }
            .store(in: &cancellables)
    }
}
