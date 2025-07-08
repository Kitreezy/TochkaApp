import Foundation
import Combine

public protocol ActivityRepository {
    func createActivity(_ activity: Activity) -> AnyPublisher<Void, Error>
    func getActivitesNearLocation(latitude: Double, longitude: Double, radius: Double) -> AnyPublisher<[Activity], Error>
    func getActivityById(_ id: String) -> AnyPublisher<Activity?, Error>
    func joinActivity(_ activityId: String, userId: String) -> AnyPublisher<Void, Error>
    func leaveActivity(_ activityId: String, userId: String) -> AnyPublisher<Void, Error>
}
