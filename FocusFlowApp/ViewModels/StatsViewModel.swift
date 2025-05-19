import Foundation
import Combine

class StatsViewModel: BaseViewModel {
    var cancellables = Set<AnyCancellable>()

    @Published var sessions: [Session] = []
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var totalFocusTime: TimeInterval = 0
    @Published var completedSessions: Int = 0

    private let dataManager: DataManager

    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        loadData()
        setupBindings()
    }

    func setupBindings() {
        // Bindings will be set up when needed
    }

    func loadData() {
        sessions = dataManager.loadSessions()
        calculateStats()
    }

    private func calculateStats() {
        // Calculate current streak
        let calendar = Calendar.current
        var currentDate = Date()
        var streak = 0

        while true {
            let sessionsForDay = sessions.filter { session in
                calendar.isDate(session.startTime, inSameDayAs: currentDate)
            }

            if sessionsForDay.isEmpty {
                break
            }

            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }

        currentStreak = streak
        bestStreak = max(bestStreak, streak)

        // Calculate total focus time and completed sessions
        totalFocusTime = sessions.reduce(0) { $0 + $1.duration }
        completedSessions = sessions.filter { $0.isCompleted }.count
    }

    func deleteSession(_ session: Session) {
        dataManager.deleteSession(session)
        loadData()
    }

    func clearAllData() {
        sessions.forEach { dataManager.deleteSession($0) }
        loadData()
    }
}
