import Combine
import SwiftUI
import SpriteKit

enum PuzzleResult { case correct, incorrect }

@MainActor
final class PuzzleViewModel: ObservableObject {

    @Published var result: PuzzleResult? = nil
    @Published var matchedPatternIndex: Int = 0  // ← tambahkan ini

    let scene: PuzzleScene = {
        let s = PuzzleScene()
        s.scaleMode = .resizeFill
        return s
    }()

    init() {
        // ← ubah parameter dari Bool ke Int (patternIndex)
        scene.onAnswerChecked = { [weak self] patternIndex in
            self?.matchedPatternIndex = patternIndex
            self?.result = .correct
        }
    }

    func checkAnswer() { scene.checkAnswer() }

    func resetPieces() {
        scene.resetPieces()
        result = nil
    }
}
