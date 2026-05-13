import Combine
import SwiftUI
import SpriteKit

enum PuzzleResult { case correct, incorrect }

@MainActor
final class PuzzleViewModel: ObservableObject {

    @Published var result: PuzzleResult? = nil

    let scene: PuzzleScene = {
        let s = PuzzleScene()
        s.scaleMode = .resizeFill
        return s
    }()

    init() {
        scene.onAnswerChecked = { [weak self] isCorrect in
            self?.result = isCorrect ? .correct : .incorrect
        }
    }

    func checkAnswer() { scene.checkAnswer() }

    func resetPieces() {
        scene.resetPieces()
        result = nil
    }
}
