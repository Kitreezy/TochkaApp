import SwiftUI
import Core

public struct CategoryCard: View {
    let category: ActivityCategory
    let isSelected: Bool
    let action: () -> Void
    
    public init(
        category: ActivityCategory,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.category = category
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(category.emoji)
                    .font(.title2)
                
                Text(category.displayName)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80, height: 80)
            .background(
                isSelected ? Color.primaryBlue : Color.secondaryGray
            )
            .cornerRadius(Constants.UI.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                    .stroke(
                        isSelected ? Color.primaryBlue : Color.gray.opacity(0.3),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .animation(.easeInOut(duration: Constants.UI.animationDuration), value: isSelected)
    }
}
