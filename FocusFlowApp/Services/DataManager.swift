import Foundation

class DataManager {
    static let shared = DataManager()

    private let userDefaults = UserDefaults.standard
    private let fileManager = FileManager.default

    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var activitiesURL: URL {
        documentsDirectory.appendingPathComponent("activities.json")
    }

    private var sessionsURL: URL {
        documentsDirectory.appendingPathComponent("sessions.json")
    }

    private var settingsURL: URL {
        documentsDirectory.appendingPathComponent("settings.json")
    }

    private init() {}

    // MARK: - Activities

    func saveActivity(_ activity: Activity) {
        var activities = loadActivities()
        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
            activities[index] = activity
        } else {
            activities.append(activity)
        }
        saveToFile(activities, to: activitiesURL)
    }

    func loadActivities() -> [Activity] {
        loadFromFile([Activity].self, from: activitiesURL) ?? []
    }

    func deleteActivity(_ activity: Activity) {
        var activities = loadActivities()
        activities.removeAll { $0.id == activity.id }
        saveToFile(activities, to: activitiesURL)
    }

    // MARK: - Sessions

    func saveSession(_ session: Session) {
        var sessions = loadSessions()
        sessions.append(session)
        saveToFile(sessions, to: sessionsURL)
    }

    func loadSessions() -> [Session] {
        loadFromFile([Session].self, from: sessionsURL) ?? []
    }

    func deleteSession(_ session: Session) {
        var sessions = loadSessions()
        sessions.removeAll { $0.id == session.id }
        saveToFile(sessions, to: sessionsURL)
    }

    // MARK: - Settings

    func saveSettings(_ settings: UserSettings) {
        saveToFile(settings, to: settingsURL)
    }

    func loadSettings() -> UserSettings {
        loadFromFile(UserSettings.self, from: settingsURL) ?? UserSettings.default
    }

    // MARK: - Private Helpers

    private func saveToFile<T: Encodable>(_ data: T, to url: URL) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(data)
            try data.write(to: url)
        } catch {
            print("Error saving data: \(error)")
        }
    }

    private func loadFromFile<T: Decodable>(_ type: T.Type, from url: URL) -> T? {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            print("Error loading data: \(error)")
            return nil
        }
    }
}
