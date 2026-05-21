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
    
    var previousPatternIndex: Int? {
        didSet {
            scene.previousPatternIndex = previousPatternIndex
        }
    }

    init() {
        scene.onAnswerChecked = { [weak self] patternIndex in
            guard let self = self else { return }

            guard !self.completedPatterns.contains(patternIndex) else {
                return
            }

            // Pattern baru — snap
            self.scene.snapAllToMidY()

            self.matchedPatternIndex = patternIndex
            self.completedPatterns.insert(patternIndex)
            self.result = .correct
        }
    }

    var isAllPatternsCompleted: Bool {
            completedPatterns.count == 5
        }
    
    func checkAnswer() { scene.checkAnswer() }
    
    func dismissResult() {
    result = nil
}
}
