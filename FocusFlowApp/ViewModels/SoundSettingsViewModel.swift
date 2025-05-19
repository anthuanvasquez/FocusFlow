import Foundation
import Combine

class SoundSettingsViewModel: BaseViewModel {
    @Published private(set) var state: State
    @Published var volume: Float = 0.5

    var cancellables = Set<AnyCancellable>()
    private let soundService = SoundService.shared
    private let dataManager = DataManager.shared

    struct State {
        var selectedSound: Sound
        var isPlaying: Bool
    }

    init() {
        let settings = dataManager.loadSettings()
        self.state = State(
            selectedSound: .bell,
            isPlaying: false
        )
        setupBindings()
    }

    func setupBindings() {
        $volume
            .sink { [weak self] newVolume in
                self?.soundService.setVolume(newVolume)
            }
            .store(in: &cancellables)
    }

    func selectSound(_ sound: Sound) {
        state.selectedSound = sound
        dataManager.saveSettings(UserSettings(
            workDuration: dataManager.loadSettings().workDuration,
            shortBreakDuration: dataManager.loadSettings().shortBreakDuration,
            longBreakDuration: dataManager.loadSettings().longBreakDuration,
            sessionsUntilLongBreak: dataManager.loadSettings().sessionsUntilLongBreak,
            soundEnabled: true,
            notificationsEnabled: dataManager.loadSettings().notificationsEnabled
        ))
    }

    func previewSound() {
        if state.isPlaying {
            soundService.stopSound()
            state.isPlaying = false
        } else {
            soundService.playSound(state.selectedSound)
            state.isPlaying = true
        }
    }
}
