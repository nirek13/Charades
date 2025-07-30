import Foundation
import CoreMotion

class GameManager: ObservableObject {
    @Published var currentWord: String = "Get Ready!"
    @Published var score: Int = 0
    @Published var timeRemaining: Int = 60
    @Published var gameOver: Bool = false

    private let wordBank = ["Unicorn", "Dancing", "Harry Potter", "Soccer", "Cooking", "Zombie", "Guitar", "Yoga", "Batman", "Swimming"]
    private var wordIndex = 0
    private var timer: Timer?
    private let motionManager = CMMotionManager()

    func startGame() {
        score = 0
        timeRemaining = 60
        gameOver = false
        shuffleWords()
        nextWord()
        startTimer()
        startMotion()
    }

    private func shuffleWords() {
        wordIndex = 0
        currentWord = wordBank.shuffled().first ?? "Ready"
    }

    private func nextWord() {
        currentWord = wordBank.randomElement() ?? "Done!"
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] t in
            guard let self = self else { return }
            self.timeRemaining -= 1
            if self.timeRemaining <= 0 {
                t.invalidate()
                self.motionManager.stopDeviceMotionUpdates()
                self.gameOver = true
            }
        }
    }

    private func startMotion() {
        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.deviceMotionUpdateInterval = 0.2
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self = self, let motion = motion else { return }
            let pitch = motion.attitude.pitch * (180 / .pi)

            if pitch > 45 {
                // Tilted up = pass
                self.nextWord()
            } else if pitch < -45 {
                // Tilted down = correct
                self.score += 1
                self.nextWord()
            }
        }
    }
}
