import Foundation

public enum TochkaError: Error, LocalizedError {
    case networkError(String)
    case authenticationRequired
    case permissionDenied
    case invalidData
    case activityFull
    case userNotFound
    case activityNotFound

    public var errorDescription: String? {
        switch self {
        case let .networkError(message):
            return "Ошибка сети: \(message)"

        case .authenticationRequired:
            return "Авторизация необходима"

        case .permissionDenied:
            return "Недостаточно прав"

        case .invalidData:
            return "Некорректсные данные"

        case .activityFull:
            return "Активность заполнена"

        case .userNotFound:
            return "Пользователь не найден"

        case .activityNotFound:
            return "Активность не найдена"
        }
    }
}
