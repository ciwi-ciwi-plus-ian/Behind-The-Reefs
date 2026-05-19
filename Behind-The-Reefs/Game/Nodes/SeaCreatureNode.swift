import SpriteKit

final class PieceNode: SKSpriteNode {

    private static let scaleFactor: CGFloat = 0.15

    let item: PuzzleItem
    let homePosition: CGPoint

    private let defaultTexture: SKTexture
    private let idleTexture: SKTexture

    private let idleActionKey = "idle-swap"

    var columnIndex: Int? = nil

    init(item: PuzzleItem, home: CGPoint) {

        self.item = item
        self.homePosition = home

        self.defaultTexture = SKTexture(imageNamed: item.rawValue)

        self.idleTexture = SKTexture(
            imageNamed: "\(item.rawValue)Idle"
        )

        let natural = defaultTexture.size()

        super.init(
            texture: defaultTexture,
            color: .clear,
            size: CGSize(
                width: natural.width * PieceNode.scaleFactor,
                height: natural.height * PieceNode.scaleFactor
            )
        )

        name = item.rawValue
        zPosition = 1

        let body = SKPhysicsBody(
            texture: defaultTexture,
            alphaThreshold: 0.05,
            size: self.size
        )

        body.isDynamic = false
        body.affectedByGravity = false
        body.categoryBitMask = 0
        body.contactTestBitMask = 0
        body.collisionBitMask = 0

        physicsBody = body

        startIdleAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func snapToColumn(_ column: Int, at position: CGPoint) {

        columnIndex = column

        let action = SKAction.move(
            to: position,
            duration: 0.18
        )

        action.timingMode = .easeOut

        run(action)
    }

    func returnToHome() {

        columnIndex = nil

        let action = SKAction.move(
            to: homePosition,
            duration: 0.22
        )

        action.timingMode = .easeOut

        run(action)
    }

    // MARK: - Idle Animation

    func restartIdleAnimation() {
        removeAction(forKey: idleActionKey)
        startIdleAnimation()
    }

    private func startIdleAnimation() {

        let randomDelay = Double.random(in: 0...1.5)

        let sequence = SKAction.sequence([
            .wait(forDuration: 2.5 + randomDelay),
            .setTexture(idleTexture),
            .wait(forDuration: 0.5),
            .setTexture(defaultTexture)
        ])

        let forever = SKAction.repeatForever(sequence)

        run(forever, withKey: idleActionKey)
    }

    deinit {
        removeAction(forKey: idleActionKey)
    }
}
