import Foundation

// MARK: - PuzzleItem

enum PuzzleItem: String, CaseIterable, Equatable {
    case yellow = "itemYellow"
    case purple = "itemPurple"
    case choco  = "itemChoco"
    case red    = "itemRed"
    case green  = "itemGreen"
    case blue   = "itemBlue"
}

// MARK: - SortCategory

enum SortCategory: String {
    case height     = "Sort by Height"
    case legsOrFins = "Sort by Legs / Fins"
    case direction  = "Sort by Direction"
    case pattern    = "Sort by Pattern"
    case dots       = "Sort by Dots"
}

// MARK: - PuzzlePattern

struct PuzzlePattern {
    let index: Int
    let category: SortCategory
    let correctOrder: [PuzzleItem]
    let keyIndex: Int

    var keySpriteName: String { "key_\(keyIndex + 1)" }
}

// MARK: - PuzzlePatternData

enum PuzzlePatternData {

    static let all: [PuzzlePattern] = [
        PuzzlePattern(index: 0, category: .height,
                      correctOrder: [.yellow, .purple, .choco, .red,    .green,  .blue  ], keyIndex: 0),
        PuzzlePattern(index: 1, category: .legsOrFins,
                      correctOrder: [.red,    .yellow, .choco, .blue,   .purple, .green ], keyIndex: 1),
        PuzzlePattern(index: 2, category: .direction,
                      correctOrder: [.green,  .choco,  .purple, .red,   .blue,   .yellow], keyIndex: 2),
        PuzzlePattern(index: 3, category: .pattern,
                      correctOrder: [.green,  .blue,   .purple, .choco, .red,    .yellow], keyIndex: 3),
        PuzzlePattern(index: 4, category: .dots,
                      correctOrder: [.purple, .red,    .blue,   .yellow, .choco, .green ], keyIndex: 4),
    ]

    static var correctSequences: [[PuzzleItem]] { all.map(\.correctOrder) }

    static func pattern(at index: Int) -> PuzzlePattern? { all[safe: index] }
}

// MARK: - Helpers

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
