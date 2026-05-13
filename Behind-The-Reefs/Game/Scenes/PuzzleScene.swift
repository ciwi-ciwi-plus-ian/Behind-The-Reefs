import SpriteKit

final class PuzzleScene: SKScene {

    // MARK: - Layout

    private enum Layout {
        static let sortingWidth: CGFloat = 520
        static let columnCount:  Int     = 6
        static let columnWidth:  CGFloat = sortingWidth / CGFloat(columnCount)  // ≈ 86.67
        static let pieceSize             = CGSize(width: 108, height: 108)
        static let slotInset:    CGFloat = 6   // gap between column edge and slot border
    }

    // Pool columns flank the 520-wide sorting area (X outside ±260).
    private var leftPoolX:  CGFloat { -(Layout.sortingWidth / 2 + Layout.pieceSize.width / 2 + 28) }
    private var rightPoolX: CGFloat {   Layout.sortingWidth / 2 + Layout.pieceSize.width / 2 + 28 }

    // MARK: - State

    private var allPieces:    [PieceNode]      = []
    private var columnPieces: [Int: PieceNode] = [:]   // column 0–5 → occupying piece
    private var slots:        [Int: SlotNode]  = [:]   // column 0–5 → slot node

    private var draggedPiece: PieceNode?
    private var dragOffset:   CGPoint = .zero

    // MARK: - Public callback (always invoked on the main thread)

    var onAnswerChecked: ((Bool) -> Void)?

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        anchorPoint     = CGPoint(x: 0.5, y: 0.5)
        setupSlots()
        setupPieces()
    }

    // MARK: - Setup

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
            let piece = PieceNode(item: item, home: homes[i], size: Layout.pieceSize)
            piece.position = homes[i]
            addChild(piece)
            allPieces.append(piece)
        }
    }

    // 3 pieces left of the sorting area, 3 pieces right — evenly spaced vertically.
    private func poolPositions() -> [CGPoint] {
        let step = size.height * 0.27
        let ys: [CGFloat] = [step, 0, -step]
        return ys.map { CGPoint(x: leftPoolX,  y: $0) }
             + ys.map { CGPoint(x: rightPoolX, y: $0) }
    }

    // MARK: - Column helpers

    /// Returns the column index (0–5) for a given X, or nil if outside the sorting area.
    private func targetColumn(for x: CGFloat) -> Int? {
        let half = Layout.sortingWidth / 2
        guard x >= -half, x <= half else { return nil }
        return min(Int((x + half) / Layout.columnWidth), Layout.columnCount - 1)
    }

    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)

        guard let piece = nodes(at: loc).compactMap({ $0 as? PieceNode }).first else { return }

        // Lift out of its column if it was placed there.
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
        piece.position = CGPoint(x: loc.x + dragOffset.x,
                                 y: loc.y + dragOffset.y)

        // Highlight the column being hovered over.
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

        if !cancelled, let col = targetColumn(for: piece.position.x) {
            // Evict whoever was already in this column.
            if let occupant = columnPieces[col], occupant !== piece {
                columnPieces.removeValue(forKey: col)
                occupant.returnToHome()
            }
            columnPieces[col] = piece
            // Snap X to column centre only — Y stays where the user released.
            piece.snapToColumn(col, at: CGPoint(x: columnCenterX(at: col), y: piece.position.y))
        } else {
            piece.returnToHome()
        }
    }

    // MARK: - Validation

    /// Reads columns 0–5, compares against the 5 predefined sequences, fires the callback.
    func checkAnswer() {
        let order = (0..<Layout.columnCount).compactMap { columnPieces[$0]?.item }
        let isCorrect = order.count == Layout.columnCount
            && PuzzlePatternData.correctSequences.contains(order)
        onAnswerChecked?(isCorrect)
    }

    /// Sends every piece back to its pool home position.
    func resetPieces() {
        columnPieces.removeAll()
        for piece in allPieces {
            piece.removeAllActions()
            piece.returnToHome()
        }
    }
}
