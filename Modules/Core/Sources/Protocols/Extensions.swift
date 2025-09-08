import Foundation
import UIKit
import SwiftUI

public extension Date {
    var timeAgoDisplay: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    var shortTimeFormat: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    var dayAndTimeFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }
}

public extension String {
    var validEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Color Extensions
public extension Color {
    // MARK: - Primary Colors
    static let primaryBlue = Color(red: 0/255, green: 122/255, blue: 255/255) // #007AFF
    static let accentGreen = Color(red: 199/255, green: 244/255, blue: 100/255) // #C7F464
    
    // MARK: - Text Colors
    static let textPrimary = Color.primary
    static let textSecondary = Color(red: 142/255, green: 142/255, blue: 147/255) // #8E8E93
    static let textOnDark = Color.white
    
    // MARK: - Background Colors
    static let backgroundMain = Color(red: 242/255, green: 242/255, blue: 247/255) // #F2F2F7
    static let backgroundCard = Color.white
    static let secondaryGray = Color(red: 242/255, green: 242/255, blue: 247/255) // #F2F2F7
    
    // MARK: - Shadow
    static let shadowColor = Color.black.opacity(0.1)
}

// MARK: - Gradient Definitions
public struct AppGradients {
    
    public static let black = LinearGradient(
        colors: [
            Color.black,
            Color(red: 0.2, green: 0.2, blue: 0.2)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    
    public static let white = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.9, green: 0.9, blue: 0.9) 
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    
    public static let purple = LinearGradient(
        colors: [
            Color(red: 162/255, green: 155/255, blue: 254/255), // #A29BFE
            Color(red: 108/255, green: 92/255, blue: 231/255)   // #6C5CE7
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let pink = LinearGradient(
        colors: [
            Color(red: 255/255, green: 107/255, blue: 157/255), // #FF6B9D
            Color(red: 196/255, green: 69/255, blue: 105/255)   // #C44569
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let green = LinearGradient(
        colors: [
            Color(red: 0/255, green: 184/255, blue: 148/255),   // #00B894
            Color(red: 0/255, green: 206/255, blue: 201/255)    // #00CEC9
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let blue = LinearGradient(
        colors: [
            Color(red: 116/255, green: 185/255, blue: 255/255), // #74B9FF
            Color(red: 9/255, green: 132/255, blue: 227/255)    // #0984E3
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let orange = LinearGradient(
        colors: [
            Color(red: 253/255, green: 203/255, blue: 110/255), // #FDCB6E
            Color(red: 225/255, green: 112/255, blue: 85/255)   // #E17055
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let appleBlue = LinearGradient(
        colors: [
            Color(red: 0/255, green: 122/255, blue: 255/255),   // #007AFF
            Color(red: 88/255, green: 86/255, blue: 214/255)    // #5856D6
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static var disabledBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.75, green: 0.75, blue: 0.75), // Светло-серый
                Color(red: 0.6, green: 0.6, blue: 0.6)     // Темнее на немного
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Gradient Extensions для удобства
public extension ShapeStyle where Self == LinearGradient {
    static var gradientPurple: LinearGradient { AppGradients.purple }
    static var gradientPink: LinearGradient { AppGradients.pink }
    static var gradientGreen: LinearGradient { AppGradients.green }
    static var gradientBlue: LinearGradient { AppGradients.blue }
    static var gradientOrange: LinearGradient { AppGradients.orange }
    static var gradientAppleBlue: LinearGradient { AppGradients.appleBlue }
}
