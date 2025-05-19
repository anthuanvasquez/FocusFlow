import SwiftUI

struct SoundSettingsView: View {
    @StateObject private var viewModel = SoundSettingsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                // Presets Section
                Section("Presets") {
                    ForEach(viewModel.state.presets) { preset in
                        PresetRow(preset: preset, isSelected: viewModel.selectedPreset?.id == preset.id)
                            .onTapGesture {
                                viewModel.selectPreset(preset)
                            }
                    }
                }

                // Ambient Sounds Section
                Section("Ambient Sounds") {
                    ForEach(viewModel.state.ambientSounds) { sound in
                        SoundRow(
                            sound: sound,
                            isSelected: viewModel.state.selectedAmbientSound?.id == sound.id,
                            volume: sound.volume
                        ) { newVolume in
                            viewModel.setVolume(newVolume, for: sound)
                        }
                        .onTapGesture {
                            viewModel.selectAmbientSound(sound)
                        }
                    }
                }

                // Music Section
                Section("Music") {
                    ForEach(viewModel.state.musicSounds) { sound in
                        SoundRow(
                            sound: sound,
                            isSelected: viewModel.state.selectedMusicSound?.id == sound.id,
                            volume: sound.volume
                        ) { newVolume in
                            viewModel.setVolume(newVolume, for: sound)
                        }
                        .onTapGesture {
                            viewModel.selectMusicSound(sound)
                        }
                    }
                }
            }
            .navigationTitle("Sound Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.toggleMute()
                    } label: {
                        Image(systemName: viewModel.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    }
                }
            }
        }
    }
}

struct PresetRow: View {
    let preset: SoundPreset
    let isSelected: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(preset.name)
                    .font(.headline)
                Text(preset.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if preset.isPremium {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }

            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
        .contentShape(Rectangle())
    }
}

struct SoundRow: View {
    let sound: Sound
    let isSelected: Bool
    let volume: Float
    let onVolumeChange: (Float) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(sound.name)
                    .font(.headline)
                if sound.isPremium {
                    Text("Premium")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }

            Slider(value: Binding(
                get: { volume },
                set: { onVolumeChange($0) }
            ), in: 0...1)
            .frame(width: 100)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationView {
        SoundSettingsView()
    }
}
