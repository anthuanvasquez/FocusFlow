import Foundation

struct Sound: Identifiable, Codable {
    let id: UUID
    let name: String
    let filename: String
    let isPremium: Bool

    init(id: UUID = UUID(), name: String, filename: String, isPremium: Bool = false) {
        self.id = id
        self.name = name
        self.filename = filename
        self.isPremium = isPremium
    }
}
