import Foundation
import AVFoundation

class SoundService {
    static let shared = SoundService()

    private var audioPlayer: AVAudioPlayer?
    private var isPlaying = false

    private init() {}

    func playSound(_ sound: Sound) {
        guard sound != .none else { return }

        if let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                isPlaying = true
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }

    func stopSound() {
        audioPlayer?.stop()
        isPlaying = false
    }

    func isSoundPlaying() -> Bool {
        return isPlaying
    }

    func setVolume(_ volume: Float) {
        audioPlayer?.volume = volume
    }
}
