import Foundation

enum SoundCategory: String, Codable {
    case ambient
    case music
    case notification
}

struct Sound: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let category: SoundCategory
    let filename: String
    let isPremium: Bool
    var volume: Float
    var isEnabled: Bool

    static func == (lhs: Sound, rhs: Sound) -> Bool {
        return lhs.id == rhs.id
    }

    static let defaultSounds: [Sound] = [
        // Ambient Sounds
        Sound(id: UUID(), name: "Rain", category: .ambient, filename: "rain", isPremium: false, volume: 0.7, isEnabled: true),
        Sound(id: UUID(), name: "Forest", category: .ambient, filename: "forest", isPremium: false, volume: 0.7, isEnabled: true),
        Sound(id: UUID(), name: "Ocean", category: .ambient, filename: "ocean", isPremium: false, volume: 0.7, isEnabled: true),
        Sound(id: UUID(), name: "Cafe", category: .ambient, filename: "cafe", isPremium: false, volume: 0.7, isEnabled: true),
        Sound(id: UUID(), name: "Fireplace", category: .ambient, filename: "fireplace", isPremium: true, volume: 0.7, isEnabled: true),

        // Music
        Sound(id: UUID(), name: "Lo-fi Beats", category: .music, filename: "lofi_beats", isPremium: false, volume: 0.5, isEnabled: true),
        Sound(id: UUID(), name: "Piano Jazz", category: .music, filename: "piano_jazz", isPremium: false, volume: 0.5, isEnabled: true),
        Sound(id: UUID(), name: "Nature Sounds", category: .music, filename: "nature_sounds", isPremium: false, volume: 0.5, isEnabled: true),
        Sound(id: UUID(), name: "White Noise", category: .music, filename: "white_noise", isPremium: false, volume: 0.5, isEnabled: true),

        // Notifications
        Sound(id: UUID(), name: "Bell", category: .notification, filename: "bell", isPremium: false, volume: 1.0, isEnabled: true),
        Sound(id: UUID(), name: "Chime", category: .notification, filename: "chime", isPremium: false, volume: 1.0, isEnabled: true),
        Sound(id: UUID(), name: "Gong", category: .notification, filename: "gong", isPremium: true, volume: 1.0, isEnabled: true)
    ]
}
