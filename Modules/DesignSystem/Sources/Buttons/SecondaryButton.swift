import SwiftUI
import Core

public struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    let isDisabled: Bool
    
    public init(
        title: String,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.isDisabled = isDisabled
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isDisabled ? .gray : .primaryBlue)
                .frame(maxWidth: .infinity)
                .frame(height: Constants.UI.buttonHeight)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                        .stroke(isDisabled ? Color.gray : Color.primaryBlue, lineWidth: 1)
                )
        }
        .disabled(isDisabled)
    }
}
