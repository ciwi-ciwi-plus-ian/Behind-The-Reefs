import SpriteKit

// Draggable puzzle piece — one per PuzzleItem.
final class PieceNode: SKSpriteNode {

    let item: PuzzleItem
    let homePosition: CGPoint

    // nil  → piece is in the pool
    // 0–5  → piece is locked into that column
    var columnIndex: Int? = nil

    init(item: PuzzleItem, home: CGPoint, size: CGSize) {
        self.item = item
        self.homePosition = home
        super.init(
            texture: SKTexture(imageNamed: item.rawValue),
            color: .clear,
            size: size
        )
        name = item.rawValue
        zPosition = 1
    }

    required init?(coder: NSCoder) { fatalError() }

    func snapToColumn(_ column: Int, at position: CGPoint) {
        columnIndex = column
        let action = SKAction.move(to: position, duration: 0.18)
        action.timingMode = .easeOut
        run(action)
    }

    func returnToHome() {
        columnIndex = nil
        let action = SKAction.move(to: homePosition, duration: 0.22)
        action.timingMode = .easeOut
        run(action)
    }
}
