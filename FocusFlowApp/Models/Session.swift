import Foundation

struct Session: Identifiable, Codable {
    let id: UUID
    let activityId: UUID
    let startTime: Date
    let endTime: Date
    let duration: TimeInterval
    let isCompleted: Bool

    init(id: UUID = UUID(), activityId: UUID, startTime: Date = Date(), endTime: Date? = nil, duration: TimeInterval, isCompleted: Bool = false) {
        self.id = id
        self.activityId = activityId
        self.startTime = startTime
        self.endTime = endTime ?? startTime.addingTimeInterval(duration)
        self.duration = duration
        self.isCompleted = isCompleted
    }
}
