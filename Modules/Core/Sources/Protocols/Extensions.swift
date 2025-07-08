import UIKit
import Foundation

extension Date {
    
    public var timeAgoDisplay: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    public var shortTimeFormat: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    public var dayAndTimeFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }
}

extension String {
    
    public var validEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    public var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
