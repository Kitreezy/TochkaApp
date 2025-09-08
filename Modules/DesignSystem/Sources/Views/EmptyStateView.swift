import SwiftUI
import Core

public struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    public init(
        icon: String,
        title: String,
        subtitle: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.primaryBlue)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let actionTitle = actionTitle, let action = action {
                PrimaryButton(title: actionTitle, action: action)
                    .frame(maxWidth: 200)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
