import Foundation

struct Session: Identifiable, Codable {
    let id: UUID
    let activityId: UUID
    let startTime: Date
    let duration: TimeInterval
    var isCompleted: Bool

    init(id: UUID = UUID(), activityId: UUID, duration: TimeInterval, isCompleted: Bool = false) {
        self.id = id
        self.activityId = activityId
        self.startTime = Date()
        self.duration = duration
        self.isCompleted = isCompleted
    }
}
