import SpriteKit

final class PieceNode: SKSpriteNode {

    private static let scaleFactor: CGFloat = 0.15

    let item: PuzzleItem
    let homePosition: CGPoint

    var columnIndex: Int? = nil

    init(item: PuzzleItem, home: CGPoint) {
        self.item = item
        self.homePosition = home
        let texture = SKTexture(imageNamed: item.rawValue)
        let natural = texture.size()
        super.init(
            texture: texture,
            color: .clear,
            size: CGSize(
                width:  natural.width  * PieceNode.scaleFactor,
                height: natural.height * PieceNode.scaleFactor
            )
        )
        name = item.rawValue
        zPosition = 1

        let body = SKPhysicsBody(texture: texture, alphaThreshold: 0.05, size: self.size)
        body.isDynamic = false
        body.affectedByGravity = false
        body.categoryBitMask = 0
        body.contactTestBitMask = 0
        body.collisionBitMask = 0
        physicsBody = body
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
