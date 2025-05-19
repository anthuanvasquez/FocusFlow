import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel: TimerViewModel
    @Environment(\.dismiss) private var dismiss

    init(activity: Activity) {
        _viewModel = StateObject(wrappedValue: TimerViewModel(activity: activity))
    }

    var body: some View {
        VStack(spacing: 30) {
            // Activity Info
            VStack(spacing: 8) {
                Text(viewModel.state.activity.name)
                    .font(.title)
                    .bold()
                if let description = viewModel.state.activity.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top)

            // Timer Circle
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(.gray)

                Circle()
                    .trim(from: 0.0, to: viewModel.progress())
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(viewModel.state.isBreak ? .green : .blue)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: viewModel.progress())

                VStack(spacing: 8) {
                    Text(viewModel.formattedTime())
                        .font(.system(size: 60, weight: .bold, design: .rounded))

                    Text(viewModel.state.isBreak ? "Break Time" : "Focus Time")
                        .font(.title3)
                        .foregroundColor(.secondary)

                    Text("Session \(viewModel.state.currentSession) of \(viewModel.state.totalSessions)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 300, height: 300)

            // Controls
            HStack(spacing: 40) {
                Button {
                    viewModel.resetTimer()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title)
                }

                Button {
                    if viewModel.state.isRunning {
                        viewModel.pauseTimer()
                    } else {
                        viewModel.startTimer()
                    }
                } label: {
                    Image(systemName: viewModel.state.isRunning ? "pause.fill" : "play.fill")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(viewModel.state.isRunning ? .red : .green)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title)
                }
            }
            .padding(.bottom)
        }
        .padding()
    }
}

#Preview {
    TimerView(activity: Activity(name: "Coding", description: "Work on the FocusFlow app"))
}
