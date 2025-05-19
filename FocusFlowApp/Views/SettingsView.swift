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
                Section("Timer Settings") {
                    Stepper(
                        "Work Duration: \(timeFormatter.string(from: viewModel.settings.workDuration) ?? "")",
                        value: Binding(
                            get: { Int(viewModel.settings.workDuration / 60) },
                            set: { viewModel.updateWorkDuration(TimeInterval($0 * 60)) }
                        ),
                        in: 1...60
                    )

                    Stepper(
                        "Short Break: \(timeFormatter.string(from: viewModel.settings.shortBreakDuration) ?? "")",
                        value: Binding(
                            get: { Int(viewModel.settings.shortBreakDuration / 60) },
                            set: { viewModel.updateShortBreakDuration(TimeInterval($0 * 60)) }
                        ),
                        in: 1...30
                    )

                    Stepper(
                        "Long Break: \(timeFormatter.string(from: viewModel.settings.longBreakDuration) ?? "")",
                        value: Binding(
                            get: { Int(viewModel.settings.longBreakDuration / 60) },
                            set: { viewModel.updateLongBreakDuration(TimeInterval($0 * 60)) }
                        ),
                        in: 5...60
                    )

                    Stepper(
                        "Sessions until Long Break: \(viewModel.settings.sessionsUntilLongBreak)",
                        value: Binding(
                            get: { viewModel.settings.sessionsUntilLongBreak },
                            set: { viewModel.updateSessionsUntilLongBreak($0) }
                        ),
                        in: 2...8
                    )
                }

                Section("Notifications") {
                    Toggle("Sound", isOn: Binding(
                        get: { viewModel.settings.soundEnabled },
                        set: { _ in viewModel.toggleSound() }
                    ))

                    Toggle("Notifications", isOn: Binding(
                        get: { viewModel.settings.notificationsEnabled },
                        set: { _ in viewModel.toggleNotifications() }
                    ))
                }

                Section {
                    Button("Reset to Defaults") {
                        viewModel.resetToDefaults()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
