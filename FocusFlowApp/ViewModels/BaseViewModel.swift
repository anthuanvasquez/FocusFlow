import Foundation
import Combine

protocol BaseViewModel: ObservableObject {
    associatedtype State

    var state: State { get }
    var cancellables: Set<AnyCancellable> { get set }

    func setupBindings()
}
