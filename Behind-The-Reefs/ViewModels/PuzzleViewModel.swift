import Combine
import SwiftUI
import SpriteKit

enum PuzzleResult { case correct, incorrect }

@MainActor
final class PuzzleViewModel: ObservableObject {

    @Published var result: PuzzleResult? = nil
    @Published var matchedPatternIndex: Int = 0
    @Published var completedPatterns: Set<Int> = []

    let scene: PuzzleScene = {
        let s = PuzzleScene()
        s.scaleMode = .resizeFill
        return s
    }()

    init() {
        // ← ubah parameter dari Bool ke Int (patternIndex)
        scene.onAnswerChecked = { [weak self] patternIndex in
            self?.matchedPatternIndex = patternIndex
            self?.completedPatterns.insert(patternIndex)
            self?.result = .correct
        }
    }

    var isAllPatternsCompleted: Bool {
            completedPatterns.count == 5
        }
    
    func checkAnswer() { scene.checkAnswer() }

    func resetPieces() {
        scene.resetPieces()
        result = nil
    }
}
