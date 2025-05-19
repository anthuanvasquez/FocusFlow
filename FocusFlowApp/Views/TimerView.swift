import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel: TimerViewModel
    @Environment(\.dismiss) private var dismiss

    init(activity: Activity) {
        _viewModel = StateObject(wrappedValue: TimerViewModel(activity: activity))
    }

    var body: some View {
        VStack(spacing: 20) {
            // Timer Circle
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(.gray)

                Circle()
                    .trim(from: 0.0, to: viewModel.progress)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(viewModel.isBreak ? .green : .blue)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: viewModel.progress)

                VStack {
                    Text(viewModel.timeString)
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                    Text(viewModel.isBreak ? "Break" : "Focus")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 300, height: 300)
            .padding()

            // Activity Info
            VStack(spacing: 8) {
                Text(viewModel.activity.name)
                    .font(.title)
                    .bold()

                if !viewModel.activity.description.isEmpty {
                    Text(viewModel.activity.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()

            // Audio Controls
            VStack(spacing: 16) {
                if let currentSound = viewModel.currentSound {
                    HStack {
                        Image(systemName: "speaker.wave.2.fill")
                        Text(currentSound.name)
                        Spacer()
                        Button(action: {
                            viewModel.toggleSound()
                        }) {
                            Image(systemName: viewModel.isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                .foregroundColor(viewModel.isSoundEnabled ? .blue : .gray)
                        }
                    }
                    .padding(.horizontal)

                    HStack {
                        Image(systemName: "speaker.fill")
                        Slider(value: $viewModel.soundVolume, in: 0...1)
                            .accentColor(.blue)
                        Image(systemName: "speaker.wave.3.fill")
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            .padding(.horizontal)

            // Timer Controls
            HStack(spacing: 40) {
                Button(action: {
                    viewModel.reset()
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title)
                        .foregroundColor(.red)
                }

                Button(action: {
                    viewModel.toggleTimer()
                }) {
                    Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }

                Button(action: {
                    viewModel.skip()
                }) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(.orange)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("End") {
                    viewModel.endSession()
                    dismiss()
                }
            }
        }
        .onAppear {
            viewModel.start()
        }
        .onDisappear {
            viewModel.pause()
        }
    }
}

#Preview {
    NavigationView {
        TimerView(activity: Activity(name: "Coding", description: "Working on the FocusFlow app"))
    }
}
