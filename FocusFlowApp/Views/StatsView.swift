import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()
    @State private var selectedDate = Date()

    private var filteredSessions: [Session] {
        let calendar = Calendar.current
        return viewModel.sessions.filter { session in
            calendar.isDate(session.startTime, inSameDayAs: selectedDate)
        }
    }

    private var totalTimeForSelectedDate: TimeInterval {
        filteredSessions.reduce(0) { $0 + $1.duration }
    }

    private var completedSessionsForSelectedDate: Int {
        filteredSessions.filter { $0.isCompleted }.count
    }

    var body: some View {
        NavigationView {
            List {
                // Date Picker Section
                Section {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                }

                // Streak Section
                Section(header: Text("Streaks")) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Current Streak")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.currentStreak) days")
                                .font(.title2)
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Best Streak")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.bestStreak) days")
                                .font(.title2)
                                .bold()
                        }
                    }
                }

                // Focus Time Section
                Section(header: Text("Focus Time")) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Total Focus Time")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(formatTime(viewModel.totalFocusTime))
                                .font(.title2)
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Completed Sessions")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.completedSessions)")
                                .font(.title2)
                                .bold()
                        }
                    }
                }

                // Selected Date Stats
                Section(header: Text("Selected Date Stats")) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Focus Time")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(formatTime(totalTimeForSelectedDate))
                                .font(.title2)
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Sessions")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(completedSessionsForSelectedDate)")
                                .font(.title2)
                                .bold()
                        }
                    }
                }

                // Sessions Section
                Section(header: Text("Sessions for Selected Date")) {
                    if filteredSessions.isEmpty {
                        Text("No sessions on this day")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(filteredSessions) { session in
                            SessionRow(session: session)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                viewModel.deleteSession(filteredSessions[index])
                            }
                        }
                    }
                }
            }
            .navigationTitle("Statistics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.clearAllData()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct SessionRow: View {
    let session: Session

    var body: some View {
        VStack(alignment: .leading) {
            Text(session.startTime, style: .date)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(formatTime(session.duration))
                .font(.headline)
        }
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

#Preview {
    StatsView()
}
