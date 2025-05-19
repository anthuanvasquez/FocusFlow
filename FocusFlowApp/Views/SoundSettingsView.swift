import SwiftUI

struct SoundSettingsView: View {
    @StateObject private var viewModel = SoundSettingsViewModel()

    var body: some View {
        Form {
            Section(header: Text("Notification Sound")) {
                ForEach([Sound.bell, .chime, .gong, .none], id: \.self) { sound in
                    HStack {
                        Text(sound.rawValue.capitalized)
                        Spacer()
                        if viewModel.state.selectedSound == sound {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectSound(sound)
                    }
                }
            }

            Section(header: Text("Preview")) {
                HStack {
                    Text("Volume")
                    Slider(value: $viewModel.volume, in: 0...1)
                }

                Button(action: {
                    viewModel.previewSound()
                }) {
                    HStack {
                        Image(systemName: viewModel.state.isPlaying ? "stop.fill" : "play.fill")
                        Text(viewModel.state.isPlaying ? "Stop" : "Preview")
                    }
                }
            }
        }
        .navigationTitle("Sound Settings")
    }
}

#Preview {
    NavigationView {
        SoundSettingsView()
    }
}
