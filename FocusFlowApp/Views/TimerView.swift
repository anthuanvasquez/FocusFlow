import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel: TimerViewModel
    @Environment(\.dismiss) private var dismiss

    init(activity: Activity) {
        _viewModel = StateObject(wrappedValue: TimerViewModel(activity: activity))
    }

    var body: some View {
        VStack(spacing: 20) {
            // Activity Info
            VStack(spacing: 8) {
                Text(viewModel.state.activity.name)
                    .font(.title)
                    .bold()

                if !viewModel.state.activity.description.isEmpty {
                    Text(viewModel.state.activity.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top)

            // Timer Display
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(.gray)

                Circle()
                    .trim(from: 0.0, to: progress())
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(timerColor())
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: viewModel.state.timeRemaining)

                VStack(spacing: 8) {
                    Text(viewModel.formattedTime(viewModel.state.timeRemaining))
                        .font(.system(size: 60, weight: .bold, design: .rounded))

                    Text(phaseText())
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 300, height: 300)
            .padding()

            // Controls
            HStack(spacing: 40) {
                Button(action: viewModel.resetTimer) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title)
                }

                Button(action: viewModel.state.isRunning ? viewModel.pauseTimer : viewModel.startTimer) {
                    Image(systemName: viewModel.state.isRunning ? "pause.fill" : "play.fill")
                        .font(.title)
                        .frame(width: 80, height: 80)
                        .background(timerColor())
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }

                Button(action: viewModel.skipTimer) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                }
            }
            .padding()

            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("End") {
                    dismiss()
                }
            }
        }
    }

    private func progress() -> Double {
        let total = viewModel.state.isBreak
            ? (viewModel.state.currentPhase == .longBreak
                ? DataManager.shared.loadSettings().longBreakDuration
                : DataManager.shared.loadSettings().shortBreakDuration)
            : DataManager.shared.loadSettings().workDuration
        return 1 - (viewModel.state.timeRemaining / total)
    }

    private func timerColor() -> Color {
        switch viewModel.state.currentPhase {
        case .work:
            return .blue
        case .shortBreak:
            return .green
        case .longBreak:
            return .purple
        }
    }

    private func phaseText() -> String {
        switch viewModel.state.currentPhase {
        case .work:
            return "Focus Time"
        case .shortBreak:
            return "Short Break"
        case .longBreak:
            return "Long Break"
        }
    }
}

#Preview {
    NavigationView {
        TimerView(activity: Activity(name: "Coding", description: "Working on the FocusFlow app"))
    }
}
