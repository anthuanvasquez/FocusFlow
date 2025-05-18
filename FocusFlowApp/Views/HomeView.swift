import SwiftUI

// Import local files
//@_implementationOnly import struct FocusFlowApp.Activity
//@_implementationOnly import class FocusFlowApp.HomeViewModel
//@_implementationOnly import struct FocusFlowApp.SettingsView
//@_implementationOnly import struct FocusFlowApp.StatsView

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.state.activities) { activity in
                    ActivityRow(activity: activity)
                        .onTapGesture {
                            viewModel.selectActivity(activity)
                        }
                }
            }
            .navigationTitle("Focus Flow")
            .toolbar {
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
