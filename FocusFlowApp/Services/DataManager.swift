import Foundation

class DataManager {
    static let shared = DataManager()

    private let userDefaults = UserDefaults.standard
    private let activitiesKey = "activities"
    private let sessionsKey = "sessions"
    private let settingsKey = "settings"

    private init() {}

    // MARK: - Activities

    func saveActivities(_ activities: [Activity]) {
        if let encoded = try? JSONEncoder().encode(activities) {
            userDefaults.set(encoded, forKey: activitiesKey)
        }
    }

    func loadActivities() -> [Activity] {
        guard let data = userDefaults.data(forKey: activitiesKey),
              let activities = try? JSONDecoder().decode([Activity].self, from: data) else {
            return []
        }
        return activities
    }

    // MARK: - Sessions

    func saveSessions(_ sessions: [Session]) {
        if let encoded = try? JSONEncoder().encode(sessions) {
            userDefaults.set(encoded, forKey: sessionsKey)
        }
    }

    func loadSessions() -> [Session] {
        guard let data = userDefaults.data(forKey: sessionsKey),
              let sessions = try? JSONDecoder().decode([Session].self, from: data) else {
            return []
        }
        return sessions
    }

    // MARK: - Settings

    func saveSettings(_ settings: UserSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            userDefaults.set(encoded, forKey: settingsKey)
        }
    }

    func loadSettings() -> UserSettings {
        guard let data = userDefaults.data(forKey: settingsKey),
              let settings = try? JSONDecoder().decode(UserSettings.self, from: data) else {
            return .default
        }
        return settings
    }
}
