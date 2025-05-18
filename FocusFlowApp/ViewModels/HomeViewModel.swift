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
    var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    func setupBindings() {
        // TODO: Setup data bindings
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
        // TODO: Implement activity loading logic
    }
}
