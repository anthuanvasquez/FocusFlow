import Foundation
import AVFoundation

class SoundService {
    static let shared = SoundService()

    private var audioPlayers: [UUID: AVAudioPlayer] = [:]
    private var isMuted = false

    private init() {
        // Preload all sounds
        for sound in Sound.defaultSounds {
            preloadSound(sound)
        }
    }

    private func preloadSound(_ sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.filename, withExtension: "mp3", subdirectory: "Sounds") else {
            print("Warning: Could not find sound file: \(sound.filename).mp3")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            audioPlayers[sound.id] = player
        } catch {
            print("Error preloading sound: \(error)")
        }
    }

    func playSound(_ sound: Sound) {
        guard !isMuted && sound.isEnabled else { return }

        // Stop existing sound if playing
        stopSound(sound)

        // Get or create player
        if let player = audioPlayers[sound.id] {
            player.volume = sound.volume
            player.numberOfLoops = -1 // Loop indefinitely
            player.play()
        } else {
            // Try to load the sound if not preloaded
            guard let url = Bundle.main.url(forResource: sound.filename, withExtension: "mp3", subdirectory: "Sounds") else {
                print("Error: Could not find sound file: \(sound.filename).mp3")
                return
            }

            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.volume = sound.volume
                player.numberOfLoops = -1 // Loop indefinitely
                player.prepareToPlay()
                player.play()
                audioPlayers[sound.id] = player
            } catch {
                print("Error playing sound: \(error)")
            }
        }
    }

    func stopSound(_ sound: Sound) {
        audioPlayers[sound.id]?.stop()
    }

    func stopAllSounds() {
        audioPlayers.values.forEach { $0.stop() }
    }

    func setVolume(_ volume: Float, for sound: Sound) {
        audioPlayers[sound.id]?.volume = volume
    }

    func mute() {
        isMuted = true
        stopAllSounds()
    }

    func unmute() {
        isMuted = false
    }

    func isPlaying(_ sound: Sound) -> Bool {
        return audioPlayers[sound.id]?.isPlaying ?? false
    }

    func toggleSound(_ sound: Sound) {
        if isPlaying(sound) {
            stopSound(sound)
        } else {
            playSound(sound)
        }
    }
}
