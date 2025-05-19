import Foundation
import Combine
import SwiftUI

class SettingsViewModel: BaseViewModel {
    @Published var workDuration: TimeInterval
    @Published var shortBreakDuration: TimeInterval
    @Published var longBreakDuration: TimeInterval
    @Published var sessionsUntilLongBreak: Int
    @Published var soundEnabled: Bool
    @Published var notificationsEnabled: Bool
    @Published var theme: Theme

    var cancellables = Set<AnyCancellable>()
    private let dataManager: DataManager

    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        let settings = dataManager.loadSettings()

        self.workDuration = settings.workDuration
        self.shortBreakDuration = settings.shortBreakDuration
        self.longBreakDuration = settings.longBreakDuration
        self.sessionsUntilLongBreak = settings.sessionsUntilLongBreak
        self.soundEnabled = settings.soundEnabled
        self.notificationsEnabled = settings.notificationsEnabled
        self.theme = settings.theme

        setupBindings()
    }

    func setupBindings() {
        // Create a publisher that emits when any of our properties change
        let publisher = $workDuration
            .merge(with: $shortBreakDuration)
            .merge(with: $longBreakDuration)
            .merge(with: $sessionsUntilLongBreak.map { _ in TimeInterval(0) })
            .merge(with: $soundEnabled.map { _ in TimeInterval(0) })
            .merge(with: $notificationsEnabled.map { _ in TimeInterval(0) })
            .merge(with: $theme.map { _ in TimeInterval(0) })

        publisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let settings = UserSettings(
                    workDuration: self.workDuration,
                    shortBreakDuration: self.shortBreakDuration,
                    longBreakDuration: self.longBreakDuration,
                    sessionsUntilLongBreak: self.sessionsUntilLongBreak,
                    soundEnabled: self.soundEnabled,
                    notificationsEnabled: self.notificationsEnabled,
                    theme: self.theme
                )
                self.dataManager.saveSettings(settings)
            }
            .store(in: &cancellables)
    }

    func resetToDefaults() {
        let defaults = UserSettings.default
        workDuration = defaults.workDuration
        shortBreakDuration = defaults.shortBreakDuration
        longBreakDuration = defaults.longBreakDuration
        sessionsUntilLongBreak = defaults.sessionsUntilLongBreak
        soundEnabled = defaults.soundEnabled
        notificationsEnabled = defaults.notificationsEnabled
        theme = defaults.theme
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
        soundEnabled.toggle()
    }

    func toggleNotifications() {
        notificationsEnabled.toggle()
    }
}
