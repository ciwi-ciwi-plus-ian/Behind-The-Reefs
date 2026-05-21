import SpriteKit

final class TutorialScene: SKScene {

    private enum Layout {
        static let targetWidth: CGFloat = 520
        static let targetHeight: CGFloat = 320
        static let targetCornerRadius: CGFloat = 16
        static let edgeInset: CGFloat = 120
    }

    private let targetNode = SKShapeNode()
    private var pieces: [PieceNode] = []
    private var draggedPiece: PieceNode?
    private var dragOffset: CGPoint = .zero
    private var completed = false

    var isDragEnabled: Bool = true
    var onTutorialCompleted: ((Bool) -> Void)?

    
    override init() {
        super.init(size: .zero)
        scaleMode = .resizeFill
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setupTarget()
        setupPieces()
    }

    private var targetRect: CGRect {
        CGRect(
            x: -Layout.targetWidth / 2,
            y: -size.height / 2,
            width: Layout.targetWidth,
            height: size.height
        )
    }

    private func setupTarget() {
        targetNode.path = UIBezierPath(
            roundedRect: targetRect,
            cornerRadius: Layout.targetCornerRadius
        ).cgPath
        targetNode.strokeColor = SKColor.white.withAlphaComponent(0.85)
        targetNode.fillColor = SKColor.white.withAlphaComponent(0.08)
        targetNode.lineWidth = 4
        targetNode.zPosition = 0
        targetNode.name = "target"
        addChild(targetNode)
    }

    private func setupPieces() {
        let leftHome = CGPoint(x: -size.width / 2 + Layout.edgeInset, y: 0)
        let rightHome = CGPoint(x: size.width / 2 - Layout.edgeInset, y: 0)

        let chocoPiece = PieceNode(item: .choco, home: leftHome)
        chocoPiece.position = leftHome
        addChild(chocoPiece)

        let purplePiece = PieceNode(item: .purple, home: rightHome)
        purplePiece.position = rightHome
        addChild(purplePiece)

        pieces = [chocoPiece, purplePiece]
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDragEnabled, let touch = touches.first else { return }
        let loc = touch.location(in: self)

        pieces.forEach { $0.zPosition = 1 }

        var hitPiece: PieceNode?
        var topZ = -CGFloat.greatestFiniteMagnitude

        physicsWorld.enumerateBodies(at: loc) { body, _ in
            guard let piece = body.node as? PieceNode, piece.zPosition > topZ else { return }
            topZ = piece.zPosition
            hitPiece = piece
        }

        guard let piece = hitPiece else { return }

        draggedPiece = piece
        dragOffset = CGPoint(x: piece.position.x - loc.x, y: piece.position.y - loc.y)

        piece.removeAllActions()
        piece.zPosition = 100
        piece.run(SKAction.scale(to: 1.12, duration: 0.1))
        HapticService.tap()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let piece = draggedPiece else { return }
        let loc = touch.location(in: self)

        let halfW = size.width / 2
        let halfH = size.height / 2

        let halfPieceW = piece.size.width / 2
        let halfPieceH = piece.size.height / 2

        let newPosition = CGPoint(
            x: min(max(loc.x + dragOffset.x, -halfW + halfPieceW), halfW - halfPieceW),
            y: min(max(loc.y + dragOffset.y, -halfH + halfPieceH), halfH - halfPieceH)
        )

        piece.position = newPosition
        targetNode.strokeColor = isInsideTarget(newPosition)
            ? SKColor.green
            : SKColor.white.withAlphaComponent(0.85)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        finishDrag(cancelled: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        finishDrag(cancelled: true)
    }

    private func finishDrag(cancelled: Bool) {
        guard let piece = draggedPiece else { return }
        draggedPiece = nil

        piece.run(SKAction.scale(to: 1.0, duration: 0.1))
        piece.zPosition = 1

        guard !cancelled else {
            piece.returnToHome()
            targetNode.strokeColor = SKColor.white.withAlphaComponent(0.85)
            return
        }

        if isInsideTarget(piece.position) {
            let adjustedPosition = clampToTarget(piece.position, piece: piece)
            piece.run(SKAction.move(to: adjustedPosition, duration: 0.18))
            HapticService.tap()
            checkCompletion()
        } else {
            piece.returnToHome()
            targetNode.strokeColor = SKColor.white.withAlphaComponent(0.85)
            HapticService.tap()
        }
    }

    private func isInsideTarget(_ point: CGPoint) -> Bool {
        targetRect.contains(point)
    }

    private func clampToTarget(_ point: CGPoint, piece: PieceNode) -> CGPoint {
        CGPoint(
            x: min(max(point.x, targetRect.minX + piece.size.width / 2), targetRect.maxX - piece.size.width / 2),
            y: min(max(point.y, targetRect.minY + piece.size.height / 2), targetRect.maxY - piece.size.height / 2)
        )
    }

    private func checkCompletion() {
        guard !completed else { return }
        if pieces.allSatisfy({ isInsideTarget($0.position) }) {
            completed = true
            targetNode.strokeColor = SKColor.green
            HapticService.tap()
            onTutorialCompleted?(true)
        }
    }
}
