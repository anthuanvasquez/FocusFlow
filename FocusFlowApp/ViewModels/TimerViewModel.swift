import Foundation
import Combine

class TimerViewModel: BaseViewModel {
    struct State {
        var activity: Activity
        var timeRemaining: TimeInterval
        var isRunning: Bool = false
        var isBreak: Bool = false
        var currentSession: Int = 1
        var totalSessions: Int = 4
    }

    @Published private(set) var state: State
    private var timer: AnyCancellable?
    var cancellables = Set<AnyCancellable>()

    init(activity: Activity, settings: UserSettings = .default) {
        self.state = State(
            activity: activity,
            timeRemaining: settings.pomodoroDuration
        )
        setupBindings()
    }

    func setupBindings() {
        // TODO: Setup sound bindings
    }

    func startTimer() {
        guard !state.isRunning else { return }
        state.isRunning = true

        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimer()
            }
    }

    func pauseTimer() {
        state.isRunning = false
        timer?.cancel()
    }

    func resetTimer() {
        state.isRunning = false
        timer?.cancel()
        state.timeRemaining = UserSettings.default.pomodoroDuration
        state.isBreak = false
        state.currentSession = 1
    }

    private func updateTimer() {
        guard state.timeRemaining > 0 else {
            handleTimerCompletion()
            return
        }

        state.timeRemaining -= 1
    }

    private func handleTimerCompletion() {
        state.isRunning = false
        timer?.cancel()

        if state.isBreak {
            // Break finished, start next session
            state.isBreak = false
            state.timeRemaining = UserSettings.default.pomodoroDuration
            state.currentSession += 1
        } else {
            // Session finished, start break
            state.isBreak = true
            state.timeRemaining = state.currentSession % state.totalSessions == 0
                ? UserSettings.default.longBreakDuration
                : UserSettings.default.shortBreakDuration
        }
    }

    func formattedTime() -> String {
        let minutes = Int(state.timeRemaining) / 60
        let seconds = Int(state.timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func progress() -> Double {
        let total = state.isBreak
            ? (state.currentSession % state.totalSessions == 0
                ? UserSettings.default.longBreakDuration
                : UserSettings.default.shortBreakDuration)
            : UserSettings.default.pomodoroDuration
        return 1 - (state.timeRemaining / total)
    }
}
