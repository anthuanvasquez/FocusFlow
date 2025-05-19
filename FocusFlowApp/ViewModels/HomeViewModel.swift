import Foundation
import Combine

class HomeViewModel: BaseViewModel {
    @Published private(set) var state: State
    @Published var isShowingAddActivity = false
    @Published var newActivityName = ""
    @Published var newActivityDescription = ""

    var cancellables = Set<AnyCancellable>()
    private let dataManager = DataManager.shared

    struct State {
        var activities: [Activity]
        var isLoading: Bool
        var error: Error?
    }

    init() {
        self.state = State(activities: [], isLoading: false, error: nil)
        setupBindings()
        loadActivities()
    }

    func setupBindings() {
        // Bindings will be set up when needed
    }

    func loadActivities() {
        state.isLoading = true
        state.activities = dataManager.loadActivities()
        state.isLoading = false
    }

    func addActivity() {
        let activity = Activity(
            name: newActivityName,
            description: newActivityDescription
        )
        dataManager.saveActivity(activity)
        loadActivities()
        cancelAddActivity()
    }

    func deleteActivity(_ activity: Activity) {
        dataManager.deleteActivity(activity)
        loadActivities()
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
