import Foundation
import Combine

class SettingsViewModel: BaseViewModel {
    @Published var settings: UserSettings {
        didSet {
            DataManager.shared.saveSettings(settings)
        }
    }

    var cancellables = Set<AnyCancellable>()

    init() {
        self.settings = DataManager.shared.loadSettings()
        setupBindings()
    }

    func setupBindings() {
        // Settings are automatically saved when changed due to the property observer
    }

    func resetToDefaults() {
        settings = .default
    }

    func updateWorkDuration(_ duration: TimeInterval) {
        settings.workDuration = duration
    }

    func updateShortBreakDuration(_ duration: TimeInterval) {
        settings.shortBreakDuration = duration
    }

    func updateLongBreakDuration(_ duration: TimeInterval) {
        settings.longBreakDuration = duration
    }

    func updateSessionsUntilLongBreak(_ count: Int) {
        settings.sessionsUntilLongBreak = count
    }

    func toggleSound() {
        settings.soundEnabled.toggle()
    }

    func toggleNotifications() {
        settings.notificationsEnabled.toggle()
    }
}
