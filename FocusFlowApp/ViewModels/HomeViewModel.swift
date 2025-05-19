import Foundation
import Combine

class HomeViewModel: BaseViewModel {
    var cancellables = Set<AnyCancellable>()

    @Published var activities: [Activity] = []
    @Published var newActivityName: String = ""
    @Published var newActivityDescription: String = ""

    private let dataManager: DataManager

    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        loadActivities()
        setupBindings()
    }

    func setupBindings() {
        // Bindings will be set up when needed
    }

    func loadActivities() {
        activities = dataManager.loadActivities()
    }

    func addActivity() {
        let activity = Activity(
            name: newActivityName,
            description: newActivityDescription
        )
        dataManager.saveActivity(activity)
        activities.append(activity)
        newActivityName = ""
        newActivityDescription = ""
    }

    func deleteActivity(_ activity: Activity) {
        dataManager.deleteActivity(activity)
        activities.removeAll { $0.id == activity.id }
    }
}
