import SwiftUI
import Core

public struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool
    let isDisabled: Bool
    
    public init(
        title: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.isLoading = isLoading
        self.isDisabled = isDisabled
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: Constants.UI.buttonHeight)
            .background(
                isDisabled || isLoading ? Color.gray : Color.primaryBlue
            )
            .cornerRadius(Constants.UI.cornerRadius)
        }
        .disabled(isDisabled || isLoading)
        .animation(.easeInOut(duration: Constants.UI.animationDuration), value: isLoading)
    }
}
