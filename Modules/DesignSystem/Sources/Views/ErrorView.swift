import SwiftUI
import Core

public struct ErrorView: View {
    let message: String
    let retryAction: (() -> Void)?
    
    public init(message: String, retryAction: (() -> Void)? = nil) {
        self.message = message
        self.retryAction = retryAction
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Ошибка")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let retryAction = retryAction {
                PrimaryButton(title: "Повторить", action: retryAction)
                    .frame(maxWidth: 200)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
