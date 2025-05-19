import Foundation
import Combine

class StatsViewModel: BaseViewModel {
    struct State {
        var sessions: [Session] = []
        var currentStreak: Int = 0
        var bestStreak: Int = 0
        var totalFocusTime: TimeInterval = 0
        var isLoading: Bool = false
        var error: Error?
    }

    @Published private(set) var state = State()
    var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
        loadStats()
    }

    func setupBindings() {
        // Save sessions whenever they change
        $state
            .map { $0.sessions }
            .sink { sessions in
                DataManager.shared.saveSessions(sessions)
            }
            .store(in: &cancellables)
    }

    func loadStats() {
        state.isLoading = true
        state.sessions = DataManager.shared.loadSessions()

        // Calculate streaks and total time
        calculateStreaks()
        calculateTotalFocusTime()

        state.isLoading = false
    }

    private func calculateStreaks() {
        let calendar = Calendar.current
        var currentStreak = 0
        var bestStreak = 0
        var currentDate = Date()

        // Sort sessions by date
        let sortedSessions = state.sessions.sorted { $0.startTime > $1.startTime }

        // Calculate current streak
        for session in sortedSessions {
            if calendar.isDate(session.startTime, inSameDayAs: currentDate) {
                continue
            }

            let daysBetween = calendar.dateComponents([.day], from: session.startTime, to: currentDate).day ?? 0
            if daysBetween == 1 {
                currentStreak += 1
                currentDate = session.startTime
            } else {
                break
            }
        }

        // Calculate best streak
        var tempStreak = 0
        var lastDate: Date?

        for session in sortedSessions {
            if let lastDate = lastDate {
                let daysBetween = calendar.dateComponents([.day], from: session.startTime, to: lastDate).day ?? 0
                if daysBetween == 1 {
                    tempStreak += 1
                    bestStreak = max(bestStreak, tempStreak)
                } else {
                    tempStreak = 0
                }
            }
            lastDate = session.startTime
        }

        state.currentStreak = currentStreak
        state.bestStreak = bestStreak
    }

    private func calculateTotalFocusTime() {
        state.totalFocusTime = state.sessions.reduce(0) { $0 + $1.duration }
    }

    func sessionsForDate(_ date: Date) -> [Session] {
        let calendar = Calendar.current
        return state.sessions.filter { session in
            calendar.isDate(session.startTime, inSameDayAs: date)
        }
    }

    func totalFocusTimeForDate(_ date: Date) -> TimeInterval {
        sessionsForDate(date).reduce(0) { $0 + $1.duration }
    }

    func formattedFocusTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
