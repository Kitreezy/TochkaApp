import Foundation

public struct ActivityLocation: Codable {
    public let name: String
    public let address: String
    public let latitude: Double
    public let longitude: Double
    
    public init(name: String,
                address: String,
                latitude: Double,
                longitude: Double
    ){
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}
