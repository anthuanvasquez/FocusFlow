import SwiftUI

// Import local files
//@_implementationOnly import struct FocusFlowApp.Activity
//@_implementationOnly import class FocusFlowApp.HomeViewModel
//@_implementationOnly import struct FocusFlowApp.SettingsView
//@_implementationOnly import struct FocusFlowApp.StatsView

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedActivity: Activity?

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.state.activities) { activity in
                    ActivityRow(activity: activity)
                        .onTapGesture {
                            selectedActivity = activity
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteActivity(activity)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .navigationTitle("Focus Flow")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showAddActivity()
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: StatsView()) {
                        Image(systemName: "chart.bar")
                    }
                }
            }
            .overlay {
                if viewModel.state.activities.isEmpty {
                    ContentUnavailableView(
                        "No Activities",
                        systemImage: "list.bullet.clipboard",
                        description: Text("Add some activities to get started")
                    )
                }
            }
            .sheet(isPresented: $viewModel.isShowingAddActivity) {
                NavigationView {
                    Form {
                        Section {
                            TextField("Activity Name", text: $viewModel.newActivityName)
                            TextField("Description (Optional)", text: $viewModel.newActivityDescription)
                        }
                    }
                    .navigationTitle("New Activity")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                viewModel.cancelAddActivity()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                viewModel.addActivity()
                            }
                            .disabled(viewModel.newActivityName.isEmpty)
                        }
                    }
                }
            }
            .sheet(item: $selectedActivity) { activity in
                TimerView(activity: activity)
            }
        }
    }
}

struct ActivityRow: View {
    let activity: Activity

    var body: some View {
        VStack(alignment: .leading) {
            Text(activity.name)
                .font(.headline)
            if let description = activity.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    HomeView()
}
