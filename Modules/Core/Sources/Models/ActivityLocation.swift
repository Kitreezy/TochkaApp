import Foundation
import CoreLocation

public struct ActivityLocation: Codable {
    public let name: String
    public let address: String
    public let latitude: Double
    public let longitude: Double

    public init(name: String,
                address: String,
                latitude: Double,
                longitude: Double)
    {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public init(name: String,
                address: String,
                coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.address = address
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
