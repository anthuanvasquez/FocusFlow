import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()
    @State private var selectedDate = Date()

    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var body: some View {
        List {
            // Streak Section
            Section("Streak") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Current Streak")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(viewModel.state.currentStreak) days")
                            .font(.title2)
                            .bold()
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text("Best Streak")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(viewModel.state.bestStreak) days")
                            .font(.title2)
                            .bold()
                    }
                }
            }

            // Total Focus Time
            Section("Total Focus Time") {
                Text(viewModel.formattedFocusTime(viewModel.state.totalFocusTime))
                    .font(.title2)
                    .bold()
            }

            // Daily Stats
            Section("Daily Stats") {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)

                let sessions = viewModel.sessionsForDate(selectedDate)
                if sessions.isEmpty {
                    Text("No sessions on this day")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(sessions) { session in
                        HStack {
                            Text(dateFormatter.string(from: session.startTime))
                            Spacer()
                            Text(viewModel.formattedFocusTime(session.duration))
                        }
                    }
                }
            }
        }
        .navigationTitle("Statistics")
    }
}

#Preview {
    NavigationView {
        StatsView()
    }
}
