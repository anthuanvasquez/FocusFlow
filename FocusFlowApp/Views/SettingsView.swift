import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss

    private let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    var body: some View {
        NavigationView {
            Form {
                Section("Theme") {
                    Picker("Theme", selection: $viewModel.theme) {
                        ForEach(Theme.allCases, id: \.self) { theme in
                            Label(theme.displayName, systemImage: theme.icon)
                                .tag(theme)
                        }
                    }
                }

                Section("Timer Settings") {
                    Stepper("Work Duration: \(Int(viewModel.workDuration / 60)) min", value: $viewModel.workDuration, in: 300...3600, step: 300)
                    Stepper("Short Break: \(Int(viewModel.shortBreakDuration / 60)) min", value: $viewModel.shortBreakDuration, in: 60...900, step: 60)
                    Stepper("Long Break: \(Int(viewModel.longBreakDuration / 60)) min", value: $viewModel.longBreakDuration, in: 300...1800, step: 300)
                    Stepper("Sessions until Long Break: \(viewModel.sessionsUntilLongBreak)", value: $viewModel.sessionsUntilLongBreak, in: 2...6)
                }

                Section("Sound Settings") {
                    Toggle("Enable Sounds", isOn: $viewModel.soundEnabled)
                    NavigationLink("Sound Settings") {
                        SoundSettingsView()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Done") {
//                        dismiss()
//                    }
//                }
//            }
        }
    }
}

private struct TimerSettingsSection: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Section(header: Text("Timer Settings")) {
            DurationRow(
                title: "Work Duration",
                value: $viewModel.workDuration,
                range: 300...3600,
                step: 300
            )

            DurationRow(
                title: "Short Break",
                value: $viewModel.shortBreakDuration,
                range: 60...600,
                step: 60
            )

            DurationRow(
                title: "Long Break",
                value: $viewModel.longBreakDuration,
                range: 300...1800,
                step: 300
            )

            HStack {
                Text("Sessions until Long Break")
                Spacer()
                Text("\(viewModel.sessionsUntilLongBreak)")
            }
            Stepper("", value: $viewModel.sessionsUntilLongBreak, in: 2...6)
        }
    }
}

private struct DurationRow: View {
    let title: String
    @Binding var value: TimeInterval
    let range: ClosedRange<TimeInterval>
    let step: TimeInterval

    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text("\(Int(value / 60)) min")
            }
            Slider(value: $value, in: range, step: step)
        }
    }
}

private struct SoundSettingsSection: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Section(header: Text("Sound Settings")) {
            NavigationLink {
                SoundSettingsView()
            } label: {
                HStack {
                    Image(systemName: "speaker.wave.2")
                    Text("Notification Sound")
                }
            }

            Toggle("Enable Notifications", isOn: $viewModel.notificationsEnabled)
        }
    }
}

private struct ResetSection: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Section {
            Button("Reset to Defaults") {
                viewModel.resetToDefaults()
            }
            .foregroundColor(.red)
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
