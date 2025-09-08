import SwiftUI
import Core

public struct LoadingView: View {
    let message: String
    
    public init(message: String = "Загрузка...") {
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .primaryBlue))
                .scaleEffect(1.2)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
