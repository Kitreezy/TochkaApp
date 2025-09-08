import Foundation

public enum Constants {
    public enum UI {
        public static let cornerRadius: CGFloat = 12
        public static let borderWidth: CGFloat = 1
        public static let shadowRadius: CGFloat = 4
        public static let animationDuration: Double = 0.3
        public static let buttonHeight: CGFloat = 56
        public static let spacing: CGFloat = 16
    }

    public enum Map {
        public static let defaultRadius: Double = 5000
        public static let maxRadius: Double = 50000
    }

    public enum Activity {
        public static let maxTitleLength = 50
        public static let maxDescriptionLength = 200
        public static let maxParticipants = 10
    }
    
    public enum Firebase {
        public static let usersCollection = "users"
        public static let activitiesCollection = "activities"
        public static let messagesCollection = "messages"
    }
}
