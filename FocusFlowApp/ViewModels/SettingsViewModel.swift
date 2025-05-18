import Foundation
import Combine

class SettingsViewModel: BaseViewModel {
    struct State {
        var settings: UserSettings
        var isLoading: Bool = false
        var error: Error?
    }

    @Published private(set) var state: State
    var cancellables = Set<AnyCancellable>()

    init(settings: UserSettings = .default) {
        self.state = State(settings: settings)
        setupBindings()
    }

    func setupBindings() {
        // TODO: Setup data bindings for settings persistence
    }

    func updatePomodoroDuration(_ duration: TimeInterval) {
        state.settings.pomodoroDuration = duration
        saveSettings()
    }

    func updateShortBreakDuration(_ duration: TimeInterval) {
        state.settings.shortBreakDuration = duration
        saveSettings()
    }

    func updateLongBreakDuration(_ duration: TimeInterval) {
        state.settings.longBreakDuration = duration
        saveSettings()
    }

    func updateSessionsUntilLongBreak(_ count: Int) {
        state.settings.sessionsUntilLongBreak = count
        saveSettings()
    }

    func updateSoundVolume(_ volume: Double) {
        state.settings.soundVolume = volume
        saveSettings()
    }

    func resetToDefaults() {
        state.settings = .default
        saveSettings()
    }

    private func saveSettings() {
        // TODO: Implement settings persistence
    }
}
