import Foundation
import Combine

class SettingsViewModel: ObservableObject, BaseViewModel {
    @Published var workDuration: TimeInterval
    @Published var shortBreakDuration: TimeInterval
    @Published var longBreakDuration: TimeInterval
    @Published var sessionsUntilLongBreak: Int
    @Published var notificationsEnabled: Bool

    var cancellables = Set<AnyCancellable>()
    private let dataManager = DataManager.shared

    init() {
        let settings = dataManager.loadSettings()
        self.workDuration = settings.workDuration
        self.shortBreakDuration = settings.shortBreakDuration
        self.longBreakDuration = settings.longBreakDuration
        self.sessionsUntilLongBreak = settings.sessionsUntilLongBreak
        self.notificationsEnabled = settings.notificationsEnabled
        setupBindings()
    }

    func setupBindings() {
        Publishers.CombineLatest4($workDuration, $shortBreakDuration, $longBreakDuration, $sessionsUntilLongBreak)
            .sink { [weak self] work, short, long, sessions in
                self?.saveSettings()
            }
            .store(in: &cancellables)

        $notificationsEnabled
            .sink { [weak self] _ in
                self?.saveSettings()
            }
            .store(in: &cancellables)
    }

    private func saveSettings() {
        let settings = UserSettings(
            workDuration: workDuration,
            shortBreakDuration: shortBreakDuration,
            longBreakDuration: longBreakDuration,
            sessionsUntilLongBreak: sessionsUntilLongBreak,
            soundEnabled: true,
            notificationsEnabled: notificationsEnabled
        )
        dataManager.saveSettings(settings)
    }

    func resetToDefaults() {
        workDuration = 25 * 60 // 25 minutes
        shortBreakDuration = 5 * 60 // 5 minutes
        longBreakDuration = 15 * 60 // 15 minutes
        sessionsUntilLongBreak = 4
        notificationsEnabled = true
    }

    func updateWorkDuration(_ duration: TimeInterval) {
        workDuration = duration
    }

    func updateShortBreakDuration(_ duration: TimeInterval) {
        shortBreakDuration = duration
    }

    func updateLongBreakDuration(_ duration: TimeInterval) {
        longBreakDuration = duration
    }

    func updateSessionsUntilLongBreak(_ count: Int) {
        sessionsUntilLongBreak = count
    }

    func toggleSound() {
        notificationsEnabled.toggle()
    }

    func toggleNotifications() {
        notificationsEnabled.toggle()
    }
}
