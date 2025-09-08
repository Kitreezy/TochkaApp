import Foundation
import FirebaseAuth

public struct User: Codable, Identifiable {
    public let id: String
    public let email: String
    public let displayName: String
    public let photoURL: String?
    public let createdAt: Date
    public let updateAt: Date
    public let rating: Double

    public init(id: String,
                email: String,
                displayName: String,
                photoURL: String? = nil,
                createdAt: Date = Date(),
                updateAt: Date = Date(),
                rating: Double = 0.0)
    {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.createdAt = createdAt
        self.updateAt = updateAt
        self.rating = rating
    }
    
    public init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.email = firebaseUser.email ?? ""
        self.displayName = firebaseUser.displayName ?? ""
        self.photoURL = firebaseUser.photoURL?.absoluteString
        self.createdAt = firebaseUser.metadata.creationDate ?? Date()
        self.updateAt = Date()
        self.rating = 0.0
    }
}
