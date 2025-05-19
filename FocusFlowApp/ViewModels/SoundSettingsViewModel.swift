import Foundation
import Combine

class SoundSettingsViewModel: ObservableObject {
    @Published private(set) var state: State
    @Published var selectedPreset: SoundPreset?
    @Published var isMuted = false

    var cancellables = Set<AnyCancellable>()
    private let soundService = SoundService.shared
    private let dataManager = DataManager.shared

    struct State {
        var presets: [SoundPreset]
        var ambientSounds: [Sound]
        var musicSounds: [Sound]
        var selectedAmbientSound: Sound?
        var selectedMusicSound: Sound?
        var isLoading: Bool
        var error: Error?
    }

    init() {
        let presets = SoundPreset.defaultPresets
        let ambientSounds = Sound.defaultSounds.filter { $0.category == .ambient }
        let musicSounds = Sound.defaultSounds.filter { $0.category == .music }

        self.state = State(
            presets: presets,
            ambientSounds: ambientSounds,
            musicSounds: musicSounds,
            selectedAmbientSound: nil,
            selectedMusicSound: nil,
            isLoading: false,
            error: nil
        )
        setupBindings()
    }

    func setupBindings() {
        // Observe changes in selected sounds
        $state
            .map { $0.selectedAmbientSound }
            .sink { [weak self] sound in
                if let sound = sound {
                    self?.soundService.playSound(sound)
                }
            }
            .store(in: &cancellables)

        $state
            .map { $0.selectedMusicSound }
            .sink { [weak self] sound in
                if let sound = sound {
                    self?.soundService.playSound(sound)
                }
            }
            .store(in: &cancellables)
    }

    func selectPreset(_ preset: SoundPreset) {
        selectedPreset = preset
        state.selectedAmbientSound = preset.ambientSound
        state.selectedMusicSound = preset.musicSound
    }

    func selectAmbientSound(_ sound: Sound) {
        state.selectedAmbientSound = sound
        state.selectedMusicSound = nil
        selectedPreset = nil
    }

    func selectMusicSound(_ sound: Sound) {
        state.selectedMusicSound = sound
    }

    func toggleMute() {
        isMuted.toggle()
        if isMuted {
            soundService.mute()
        } else {
            soundService.unmute()
            if let ambient = state.selectedAmbientSound {
                soundService.playSound(ambient)
            }
            if let music = state.selectedMusicSound {
                soundService.playSound(music)
            }
        }
    }

    func stopAllSounds() {
        soundService.stopAllSounds()
        state.selectedAmbientSound = nil
        state.selectedMusicSound = nil
        selectedPreset = nil
    }

    func setVolume(_ volume: Float, for sound: Sound) {
        soundService.setVolume(volume, for: sound)
    }
}
