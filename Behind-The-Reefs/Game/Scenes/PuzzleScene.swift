import SpriteKit

final class PuzzleScene: SKScene {

    private enum Layout {
        static let sortingWidth: CGFloat = 520
        static let columnCount:  Int     = 6
        static let columnWidth:  CGFloat = sortingWidth / CGFloat(columnCount)
        static let slotInset:    CGFloat = 6
        static let poolMargin:   CGFloat = 150
    }

    private let leftPoolX  = -(Layout.sortingWidth / 2 + Layout.poolMargin)
    private let rightPoolX =   Layout.sortingWidth / 2 + Layout.poolMargin

    private var allPieces:    [PieceNode]      = []
    private var columnPieces: [Int: PieceNode] = [:]
    private var slots:        [Int: SlotNode]  = [:]

    private var draggedPiece:     PieceNode?
    private var dragOffset:       CGPoint = .zero
    private var dragSourceColumn: Int?    = nil

    var onAnswerChecked: ((Bool) -> Void)?

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        anchorPoint     = CGPoint(x: 0.5, y: 0.5)
        setupSlots()
        setupPieces()
    }

    private func columnCenterX(at index: Int) -> CGFloat {
        -Layout.sortingWidth / 2 + Layout.columnWidth * (CGFloat(index) + 0.5)
    }

    private func setupSlots() {
        let hw   = Layout.columnWidth / 2 - Layout.slotInset
        let rect = CGRect(x: -hw, y: -size.height / 2, width: hw * 2, height: size.height)

        for i in 0..<Layout.columnCount {
            let slot = SlotNode(columnIndex: i, rect: rect)
            slot.position = CGPoint(x: columnCenterX(at: i), y: 0)
            addChild(slot)
            slots[i] = slot
        }
    }

    private func setupPieces() {
        let homes = poolPositions()
        let items = PuzzleItem.allCases.shuffled()
        for (i, item) in items.enumerated() {
            let piece = PieceNode(item: item, home: homes[i])
            piece.position = homes[i]
            addChild(piece)
            allPieces.append(piece)
        }
    }

    private func poolPositions() -> [CGPoint] {
        let step = size.height * 0.27
        let ys: [CGFloat] = [step, 0, -step]
        return ys.map { CGPoint(x: leftPoolX,  y: $0) }
             + ys.map { CGPoint(x: rightPoolX, y: $0) }
    }

    private func targetColumn(for x: CGFloat) -> Int? {
        let half = Layout.sortingWidth / 2
        guard x >= -half, x <= half else { return nil }
        return min(Int((x + half) / Layout.columnWidth), Layout.columnCount - 1)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)

        var hitPiece: PieceNode?
        var topZ = -CGFloat.greatestFiniteMagnitude
        physicsWorld.enumerateBodies(at: loc) { body, _ in
            guard let p = body.node as? PieceNode, p.zPosition > topZ else { return }
            topZ = p.zPosition
            hitPiece = p
        }
        guard let piece = hitPiece else { return }

        dragSourceColumn = piece.columnIndex
        if let col = piece.columnIndex {
            columnPieces.removeValue(forKey: col)
            slots[col]?.setHighlighted(false)
            piece.columnIndex = nil
        }

        draggedPiece = piece
        dragOffset   = CGPoint(x: piece.position.x - loc.x,
                               y: piece.position.y - loc.y)

        piece.removeAllActions()
        piece.zPosition = 10
        piece.run(SKAction.scale(to: 1.12, duration: 0.1))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let piece = draggedPiece else { return }
        let loc = touch.location(in: self)
        let halfW = size.width / 2
        let halfH = size.height / 2
        piece.position = CGPoint(
            x: min(max(loc.x + dragOffset.x, -halfW), halfW),
            y: min(max(loc.y + dragOffset.y, -halfH), halfH)
        )

        let hovered = targetColumn(for: piece.position.x)
        slots.forEach { $1.setHighlighted($0 == hovered) }
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
        slots.values.forEach { $0.setHighlighted(false) }

        guard !cancelled, let targetCol = targetColumn(for: piece.position.x) else { return }

        if let occupant = columnPieces[targetCol], occupant !== piece {
            columnPieces.removeValue(forKey: targetCol)

            if let sourceCol = dragSourceColumn {
                columnPieces[sourceCol] = occupant
                occupant.snapToColumn(sourceCol, at: CGPoint(x: columnCenterX(at: sourceCol), y: occupant.position.y))
            } else {
                occupant.columnIndex = nil
                let pushX = columnCenterX(at: targetCol) < 0 ? leftPoolX : rightPoolX
                let move = SKAction.move(to: CGPoint(x: pushX, y: occupant.position.y), duration: 0.18)
                move.timingMode = .easeOut
                occupant.run(move)
            }
        } else if let sourceCol = dragSourceColumn, sourceCol != targetCol {
            columnPieces.removeValue(forKey: sourceCol)
        }

        columnPieces[targetCol] = piece
        piece.snapToColumn(targetCol, at: CGPoint(x: columnCenterX(at: targetCol), y: piece.position.y))
    }

    func checkAnswer() {
        let order = (0..<Layout.columnCount).compactMap { columnPieces[$0]?.item }
        let isCorrect = order.count == Layout.columnCount
            && PuzzlePatternData.correctSequences.contains(order)
        onAnswerChecked?(isCorrect)
    }

    func resetPieces() {
        columnPieces.removeAll()
        for piece in allPieces {
            piece.removeAllActions()
            piece.returnToHome()
        }
    }
}
