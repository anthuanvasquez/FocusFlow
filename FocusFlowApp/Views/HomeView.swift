import SwiftUI

// Import local files
//@_implementationOnly import struct FocusFlowApp.Activity
//@_implementationOnly import class FocusFlowApp.HomeViewModel
//@_implementationOnly import struct FocusFlowApp.SettingsView
//@_implementationOnly import struct FocusFlowApp.StatsView

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingAddActivity = false
    @State private var selectedActivity: Activity?

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.activities) { activity in
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
                    Button(action: {
                        showingAddActivity = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddActivity) {
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
                                showingAddActivity = false
                                viewModel.newActivityName = ""
                                viewModel.newActivityDescription = ""
                            }
                        }

                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                viewModel.addActivity()
                                showingAddActivity = false
                            }
                            .disabled(viewModel.newActivityName.isEmpty)
                        }
                    }
                }
            }
            .sheet(item: $selectedActivity) { activity in
                NavigationView {
                    TimerView(activity: activity)
                }
            }
            .overlay {
                if viewModel.activities.isEmpty {
                    ContentUnavailableView(
                        "No Activities",
                        systemImage: "list.bullet.clipboard",
                        description: Text("Add some activities to get started")
                    )
                }
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
            if !activity.description.isEmpty {
                Text(activity.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    HomeView()
}
