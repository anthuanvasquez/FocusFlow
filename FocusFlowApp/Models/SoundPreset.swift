import Foundation

struct SoundPreset: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let description: String
    let ambientSound: Sound
    let musicSound: Sound?
    let isPremium: Bool

    static func == (lhs: SoundPreset, rhs: SoundPreset) -> Bool {
        return lhs.id == rhs.id
    }

    static let defaultPresets: [SoundPreset] = {
        let sounds = Sound.defaultSounds
        return [
            // Focus Presets
            SoundPreset(
                id: UUID(),
                name: "Deep Focus",
                description: "Perfect for intense work sessions",
                ambientSound: sounds.first(where: { $0.name == "Rain" })!,
                musicSound: sounds.first(where: { $0.name == "Lo-fi Beats" }),
                isPremium: false
            ),
            SoundPreset(
                id: UUID(),
                name: "Nature's Study",
                description: "Forest sounds with gentle piano",
                ambientSound: sounds.first(where: { $0.name == "Forest" })!,
                musicSound: sounds.first(where: { $0.name == "Piano Jazz" }),
                isPremium: false
            ),
            SoundPreset(
                id: UUID(),
                name: "Cafe Vibes",
                description: "Cafe ambiance with lo-fi beats",
                ambientSound: sounds.first(where: { $0.name == "Cafe" })!,
                musicSound: sounds.first(where: { $0.name == "Lo-fi Beats" }),
                isPremium: false
            ),
            SoundPreset(
                id: UUID(),
                name: "Ocean Meditation",
                description: "Calming ocean waves with nature sounds",
                ambientSound: sounds.first(where: { $0.name == "Ocean" })!,
                musicSound: sounds.first(where: { $0.name == "Nature Sounds" }),
                isPremium: true
            ),
            SoundPreset(
                id: UUID(),
                name: "Cozy Fireplace",
                description: "Warm fireplace with piano jazz",
                ambientSound: sounds.first(where: { $0.name == "Fireplace" })!,
                musicSound: sounds.first(where: { $0.name == "Piano Jazz" }),
                isPremium: true
            )
        ]
    }()
}
