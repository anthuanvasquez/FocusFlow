import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        Form {
            Section("Pomodoro Duration") {
                DurationSlider(
                    value: Binding(
                        get: { viewModel.state.settings.pomodoroDuration },
                        set: { viewModel.updatePomodoroDuration($0) }
                    ),
                    range: 5...60,
                    title: "Focus Time"
                )
            }

            Section("Break Duration") {
                DurationSlider(
                    value: Binding(
                        get: { viewModel.state.settings.shortBreakDuration },
                        set: { viewModel.updateShortBreakDuration($0) }
                    ),
                    range: 1...15,
                    title: "Short Break"
                )

                DurationSlider(
                    value: Binding(
                        get: { viewModel.state.settings.longBreakDuration },
                        set: { viewModel.updateLongBreakDuration($0) }
                    ),
                    range: 5...30,
                    title: "Long Break"
                )

                Stepper(
                    "Sessions until long break: \(viewModel.state.settings.sessionsUntilLongBreak)",
                    value: Binding(
                        get: { viewModel.state.settings.sessionsUntilLongBreak },
                        set: { viewModel.updateSessionsUntilLongBreak($0) }
                    ),
                    in: 2...6
                )
            }

            Section("Sound") {
                Slider(
                    value: Binding(
                        get: { viewModel.state.settings.soundVolume },
                        set: { viewModel.updateSoundVolume($0) }
                    ),
                    in: 0...1
                ) {
                    Text("Volume")
                }
            }

            Section {
                Button("Reset to Defaults") {
                    viewModel.resetToDefaults()
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Settings")
    }
}

struct DurationSlider: View {
    @Binding var value: TimeInterval
    let range: ClosedRange<Double>
    let title: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            HStack {
                Slider(
                    value: Binding(
                        get: { value / 60 },
                        set: { value = $0 * 60 }
                    ),
                    in: range
                )
                Text("\(Int(value / 60)) min")
                    .frame(width: 50)
            }
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
