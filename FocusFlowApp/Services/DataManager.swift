import Foundation

class DataManager {
    static let shared = DataManager()

    private let userDefaults = UserDefaults.standard
    private let activitiesKey = "activities"
    private let sessionsKey = "sessions"
    private let settingsKey = "settings"

    private init() {}

    // MARK: - Activities

    func loadActivities() -> [Activity] {
        guard let data = userDefaults.data(forKey: activitiesKey),
              let activities = try? JSONDecoder().decode([Activity].self, from: data) else {
            return []
        }
        return activities
    }

    func saveActivity(_ activity: Activity) {
        var activities = loadActivities()
        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
            activities[index] = activity
        } else {
            activities.append(activity)
        }
        saveActivities(activities)
    }

    func saveActivities(_ activities: [Activity]) {
        if let data = try? JSONEncoder().encode(activities) {
            userDefaults.set(data, forKey: activitiesKey)
        }
    }

    func deleteActivity(_ activity: Activity) {
        var activities = loadActivities()
        activities.removeAll { $0.id == activity.id }
        saveActivities(activities)
    }

    // MARK: - Sessions

    func loadSessions() -> [Session] {
        guard let data = userDefaults.data(forKey: sessionsKey),
              let sessions = try? JSONDecoder().decode([Session].self, from: data) else {
            return []
        }
        return sessions
    }

    func saveSession(_ session: Session) {
        var sessions = loadSessions()
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        } else {
            sessions.append(session)
        }
        saveSessions(sessions)
    }

    func saveSessions(_ sessions: [Session]) {
        if let data = try? JSONEncoder().encode(sessions) {
            userDefaults.set(data, forKey: sessionsKey)
        }
    }

    func deleteSession(_ session: Session) {
        var sessions = loadSessions()
        sessions.removeAll { $0.id == session.id }
        saveSessions(sessions)
    }

    // MARK: - Settings

    func loadSettings() -> UserSettings {
        guard let data = userDefaults.data(forKey: settingsKey),
              let settings = try? JSONDecoder().decode(UserSettings.self, from: data) else {
            return .default
        }
        return settings
    }

    func saveSettings(_ settings: UserSettings) {
        if let data = try? JSONEncoder().encode(settings) {
            userDefaults.set(data, forKey: settingsKey)
        }
    }
}
