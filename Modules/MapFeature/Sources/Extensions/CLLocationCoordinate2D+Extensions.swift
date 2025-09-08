import Foundation
import CoreLocation

// MARK: - CLLocationCoordinate2D Codable conformance
extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    private enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
}

// MARK: - CLLocationCoordinate2D Extensions
public extension CLLocationCoordinate2D {
    // Стокгольм по умолчанию для тестирования
    static let rostovOnDon = CLLocationCoordinate2D(latitude: 47.2357, longitude: 39.7015)
    
    // Проверка валидности координат
    var isValid: Bool {
        latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180
    }
    
    var isValidLocation: Bool {
        latitude != 0 && longitude != 0 && isValid
    }
    
    // Расстояние до другой точки
    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: latitude, longitude: longitude)
        let location2 = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return location1.distance(from: location2)
    }
    
    // Отображение расстояния в удобном формате
    func distanceDisplay(to other: CLLocationCoordinate2D) -> String {
        let distance = distance(to: other)
        
        if distance < 1000 {
            return "\(Int(distance)) м"
        } else {
            return String(format: "%.1f км", distance / 1000)
        }
    }
}
