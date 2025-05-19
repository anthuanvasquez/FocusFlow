import Foundation
import Combine

class TimerViewModel: BaseViewModel {
    struct State {
        var activity: Activity
        var timeRemaining: TimeInterval
        var isRunning: Bool
        var isBreak: Bool
        var completedSessions: Int
        var currentPhase: TimerPhase
    }

    enum TimerPhase {
        case work
        case shortBreak
        case longBreak
    }

    @Published private(set) var state: State
    var cancellables = Set<AnyCancellable>()

    private var timer: AnyCancellable?
    private let settings: UserSettings

    init(activity: Activity) {
        self.settings = DataManager.shared.loadSettings()
        self.state = State(
            activity: activity,
            timeRemaining: settings.workDuration,
            isRunning: false,
            isBreak: false,
            completedSessions: 0,
            currentPhase: .work
        )
        setupBindings()
    }

    func setupBindings() {
        // Timer bindings will be set up when needed
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
        timer = nil
    }

    func resetTimer() {
        pauseTimer()
        state.timeRemaining = settings.workDuration
        state.isBreak = false
        state.currentPhase = .work
    }

    func skipTimer() {
        pauseTimer()
        if state.isBreak {
            startWorkPhase()
        } else {
            startBreakPhase()
        }
    }

    private func updateTimer() {
        guard state.timeRemaining > 0 else {
            handleTimerCompletion()
            return
        }

        state.timeRemaining -= 1
    }

    private func handleTimerCompletion() {
        pauseTimer()

        if state.isBreak {
            startWorkPhase()
        } else {
            state.completedSessions += 1
            startBreakPhase()
        }
    }

    private func startWorkPhase() {
        state.isBreak = false
        state.currentPhase = .work
        state.timeRemaining = settings.workDuration
        startTimer()
    }

    private func startBreakPhase() {
        state.isBreak = true

        if state.completedSessions % settings.sessionsUntilLongBreak == 0 {
            state.currentPhase = .longBreak
            state.timeRemaining = settings.longBreakDuration
        } else {
            state.currentPhase = .shortBreak
            state.timeRemaining = settings.shortBreakDuration
        }

        startTimer()
    }

    func formattedTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
