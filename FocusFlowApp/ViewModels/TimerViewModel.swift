import Foundation
import Combine

class TimerViewModel: BaseViewModel {
    var cancellables = Set<AnyCancellable>()

    @Published var activity: Activity
    @Published var timeRemaining: TimeInterval
    @Published var isRunning: Bool
    @Published var isBreak: Bool
    @Published var completedSessions: Int
    @Published var currentPhase: TimerPhase
    @Published var currentSound: Sound?
    @Published var isSoundEnabled: Bool
    @Published var soundVolume: Float

    var progress: Double {
        let total = isBreak
            ? (currentPhase == .longBreak ? settings.longBreakDuration : settings.shortBreakDuration)
            : settings.workDuration
        return 1 - (timeRemaining / total)
    }

    var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private var timer: AnyCancellable?
    private let settings: UserSettings
    private let soundService: SoundService
    private let notificationService: NotificationService

    init(activity: Activity,
         soundService: SoundService = .shared,
         notificationService: NotificationService = .shared) {
        self.activity = activity
        self.settings = DataManager.shared.loadSettings()
        self.soundService = soundService
        self.notificationService = notificationService

        self.timeRemaining = settings.workDuration
        self.isRunning = false
        self.isBreak = false
        self.completedSessions = 0
        self.currentPhase = .work
        self.isSoundEnabled = settings.soundEnabled
        self.soundVolume = 1.0

        setupBindings()
    }

    func setupBindings() {
        $soundVolume
            .sink { [weak self] volume in
                guard let self = self, let sound = self.currentSound else { return }
                self.soundService.setVolume(volume, for: sound)
            }
            .store(in: &cancellables)

        $isSoundEnabled
            .sink { [weak self] enabled in
                guard let self = self else { return }
                if enabled {
                    self.soundService.unmute()
                    if let sound = self.currentSound {
                        self.soundService.playSound(sound)
                    }
                } else {
                    self.soundService.mute()
                }
            }
            .store(in: &cancellables)
    }

    func start() {
        isRunning = true
        startTimer()
        if isSoundEnabled, let sound = currentSound {
            soundService.playSound(sound)
        }

        // Schedule notification for timer end
        notificationService.scheduleTimerNotification(
            for: activity,
            timeRemaining: timeRemaining,
            isBreak: isBreak
        )
    }

    func pause() {
        isRunning = false
        timer?.cancel()
        soundService.stopAllSounds()
        notificationService.cancelTimerNotification(for: activity.id)
    }

    func toggleTimer() {
        if isRunning {
            pause()
        } else {
            start()
        }
    }

    func reset() {
        pause()
        timeRemaining = isBreak
            ? (currentPhase == .longBreak ? settings.longBreakDuration : settings.shortBreakDuration)
            : settings.workDuration
    }

    func skip() {
        pause()
        if isBreak {
            startWorkPhase()
        } else {
            startBreakPhase()
        }
    }

    func endSession() {
        pause()
        saveSession()
    }

    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.cancel()
                    if self.isBreak {
                        self.startWorkPhase()
                    } else {
                        self.startBreakPhase()
                    }
                }
            }
    }

    private func startWorkPhase() {
        isBreak = false
        currentPhase = .work
        timeRemaining = settings.workDuration
        currentSound = Sound.workSounds.randomElement()
        start()
    }

    private func startBreakPhase() {
        isBreak = true
        completedSessions += 1

        if completedSessions % settings.sessionsUntilLongBreak == 0 {
            currentPhase = .longBreak
            timeRemaining = settings.longBreakDuration
        } else {
            currentPhase = .shortBreak
            timeRemaining = settings.shortBreakDuration
        }

        currentSound = Sound.breakSounds.randomElement()
        start()

        // Schedule notification for break end
        notificationService.scheduleBreakEndNotification(timeRemaining: timeRemaining)
    }

    private func saveSession() {
        let session = Session(
            activityId: activity.id,
            duration: settings.workDuration - timeRemaining,
            isCompleted: true
        )
        DataManager.shared.saveSession(session)
    }

    func toggleSound() {
        isSoundEnabled.toggle()
    }
}
