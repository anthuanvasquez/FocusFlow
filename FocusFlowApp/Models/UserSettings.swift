import Foundation

struct UserSettings: Codable {
    var workDuration: TimeInterval
    var shortBreakDuration: TimeInterval
    var longBreakDuration: TimeInterval
    var sessionsUntilLongBreak: Int
    var soundEnabled: Bool
    var notificationsEnabled: Bool

    static let `default` = UserSettings(
        workDuration: 25 * 60,
        shortBreakDuration: 5 * 60,
        longBreakDuration: 15 * 60,
        sessionsUntilLongBreak: 4,
        soundEnabled: true,
        notificationsEnabled: true
    )
}
