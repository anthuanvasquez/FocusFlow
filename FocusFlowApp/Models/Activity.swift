import Foundation

struct Activity: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String?
    var createdAt: Date
    var isCompleted: Bool

    init(id: UUID = UUID(), name: String, description: String? = nil, createdAt: Date = Date(), isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
}
