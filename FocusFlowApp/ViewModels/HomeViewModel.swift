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
        // Save activities whenever they change
        $state
            .map { $0.activities }
            .sink { activities in
                DataManager.shared.saveActivities(activities)
            }
            .store(in: &cancellables)
    }

    func selectActivity(_ activity: Activity) {
        state.selectedActivity = activity
    }

    func startSession(for activity: Activity) {
        // TODO: Implement session start logic
    }

    func loadActivities() {
        state.isLoading = true
        state.activities = DataManager.shared.loadActivities()

        // Add sample data if no activities exist
        if state.activities.isEmpty {
            state.activities = [
                Activity(name: "Coding", description: "Programming and development work"),
                Activity(name: "Reading", description: "Reading books and articles"),
                Activity(name: "Exercise", description: "Physical activity and workouts")
            ]
        }

        state.isLoading = false
    }

    func addActivity() {
        guard !newActivityName.isEmpty else { return }

        let activity = Activity(
            name: newActivityName,
            description: newActivityDescription
        )

        state.activities.append(activity)
        cancelAddActivity()
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
