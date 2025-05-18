import Foundation
import Combine

class HomeViewModel: BaseViewModel {
    struct State {
        var activities: [Activity] = []
        var selectedActivity: Activity?
        var isLoading: Bool = false
        var error: Error?
    }

    @Published private(set) var state = State()
    @Published var isShowingAddActivity = false
    @Published var newActivityName = ""
    @Published var newActivityDescription = ""

    var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
        loadActivities()
    }

    func setupBindings() {
        // TODO: Setup data bindings for persistence
    }

    func selectActivity(_ activity: Activity) {
        state.selectedActivity = activity
    }

    func startSession() {
        guard let activity = state.selectedActivity else { return }
        // TODO: Implement session start logic
    }

    func loadActivities() {
        state.isLoading = true
        // TODO: Load activities from persistence
        // For now, we'll add some sample activities
        state.activities = [
            Activity(name: "Coding", description: "Work on the FocusFlow app"),
            Activity(name: "Reading", description: "Read technical documentation"),
            Activity(name: "Exercise", description: "30 minutes workout")
        ]
        state.isLoading = false
    }

    func addActivity() {
        guard !newActivityName.isEmpty else { return }

        let newActivity = Activity(
            name: newActivityName,
            description: newActivityDescription.isEmpty ? nil : newActivityDescription
        )

        state.activities.append(newActivity)
        newActivityName = ""
        newActivityDescription = ""
        isShowingAddActivity = false
    }

    func deleteActivity(_ activity: Activity) {
        state.activities.removeAll { $0.id == activity.id }
    }

    func showAddActivity() {
        isShowingAddActivity = true
    }

    func cancelAddActivity() {
        isShowingAddActivity = false
        newActivityName = ""
        newActivityDescription = ""
    }
}
