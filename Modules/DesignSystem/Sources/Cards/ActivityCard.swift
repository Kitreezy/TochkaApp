import SwiftUI
import Core

public struct ActivityCard: View {
    let activity: Activity
    let action: () -> Void
    
    public init(activity: Activity, action: @escaping () -> Void) {
        self.activity = activity
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                // Заголовок с иконкой категории
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(activity.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Text(activity.location.name)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Иконка категории в кружке (как в макете)
                    Circle()
                        .fill(Color.accentGreen.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(activity.category.emoji)
                                .font(.title3)
                        )
                }
                
                // Описание
                Text(activity.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Метаинформация (как в макете)
                HStack {
                    // Участники
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.caption)
                            .foregroundColor(.primaryBlue)
                        Text("\(activity.participantIds.count)")
                        if let max = activity.maxParticipants {
                            Text("/ \(max)")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    // Время
                    Text(activity.dateTime.dayAndTimeFormat)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondaryGray)
                        .cornerRadius(8)
                }
            }
            .padding(16)
            .background(Color.backgroundCard)
            .cornerRadius(16) // Больше скругления как в макете
            .shadow(color: Color.shadowColor, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
