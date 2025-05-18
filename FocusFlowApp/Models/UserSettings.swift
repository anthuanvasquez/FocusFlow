import Foundation

struct UserSettings: Codable {
    var pomodoroDuration: TimeInterval
    var shortBreakDuration: TimeInterval
    var longBreakDuration: TimeInterval
    var sessionsUntilLongBreak: Int
    var soundVolume: Double
    var selectedSoundIds: [UUID]

    static let `default` = UserSettings(
        pomodoroDuration: 25 * 60, // 25 minutes
        shortBreakDuration: 5 * 60, // 5 minutes
        longBreakDuration: 15 * 60, // 15 minutes
        sessionsUntilLongBreak: 4,
        soundVolume: 0.5,
        selectedSoundIds: []
    )
}
