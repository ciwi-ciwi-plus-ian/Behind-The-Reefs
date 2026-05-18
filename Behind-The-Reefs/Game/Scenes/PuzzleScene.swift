import AVFoundation
import SpriteKit

final class PuzzleScene: SKScene {

    private enum Layout {
        static let sortingWidth: CGFloat = 520
        static let columnCount:  Int     = 6
        static let columnWidth:  CGFloat = sortingWidth / CGFloat(columnCount)
        static let slotInset:    CGFloat = 6
        static let poolMargin:   CGFloat = 65
    }

    private let leftPoolX  = -(Layout.sortingWidth / 2 + Layout.poolMargin)
    private let rightPoolX =   Layout.sortingWidth / 2 + Layout.poolMargin

    private var allPieces:    [PieceNode]      = []
    private var columnPieces: [Int: PieceNode] = [:]
    private var slots:        [Int: SlotNode]  = [:]

    private var draggedPiece:     PieceNode?
    private var dragOffset:       CGPoint = .zero
    private var dragSourceColumn: Int?    = nil

    private var bgmPlayer: AVAudioPlayer?
    private let snapHaptic = UIImpactFeedbackGenerator(style: .light)

    var onAnswerChecked: ((Int) -> Void)?

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        anchorPoint     = CGPoint(x: 0.5, y: 0.5)
        setupSlots()
        setupPieces()
        startHintTimer()
        startBGM()
        snapHaptic.prepare()
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
        for (item, pos) in poolLayout() {
            let piece = PieceNode(item: item, home: pos)
            piece.position = pos
            addChild(piece)
            allPieces.append(piece)
        }
    }

    private func poolLayout() -> [(PuzzleItem, CGPoint)] {
        let positions: [(CGPoint, CGPoint)] = [
            (CGPoint(x: leftPoolX + 15, y:  100),
             CGPoint(x: rightPoolX - 15, y:  100)),
            (CGPoint(x: leftPoolX - 15, y:    0),
             CGPoint(x: rightPoolX + 15, y:    0)),
            (CGPoint(x: leftPoolX + 25, y: -110),
             CGPoint(x: rightPoolX - 25, y: -110)),
        ]

        let colorPairs: [[(PuzzleItem, PuzzleItem)]] = [
            [(.red, .yellow), (.choco, .blue), (.purple, .green)],
            [(.blue, .choco), (.red, .yellow), (.green, .purple)],
        ]

        let pairs = colorPairs.randomElement()!
        return zip(pairs, positions).flatMap { (pair, pos) in
            [(pair.0, pos.0), (pair.1, pos.1)]
        }
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

        let halfPieceW = piece.size.width / 2
        let halfPieceH = piece.size.height / 2

        piece.position = CGPoint(
            x: min(
                max(loc.x + dragOffset.x, -halfW + halfPieceW),
                halfW - halfPieceW
            ),
            y: min(
                max(loc.y + dragOffset.y, -halfH + halfPieceH),
                halfH - halfPieceH
            )
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
        snapHaptic.impactOccurred(intensity: 0.5)

        if columnPieces.count == Layout.columnCount {
            checkAnswer()
        }
    }

    func checkAnswer() {
        let order = (0..<Layout.columnCount).compactMap { columnPieces[$0]?.item }
        guard order.count == Layout.columnCount else { return }

        // Cari index pattern mana yang cocok
        guard let matchedIndex = PuzzlePatternData.all.firstIndex(where: {
            $0.correctOrder == order
        }) else { return }

        // Kirim patternIndex ke ViewModel
        onAnswerChecked?(matchedIndex)  // ← kirim index, bukan true/false
    }

   func snapAllToMidY() {
        for (col, piece) in columnPieces {
            let target = CGPoint(x: columnCenterX(at: col), y: 0)
            let move = SKAction.move(to: target, duration: 0.35)
            move.timingMode = .easeOut
            piece.run(move)
        }
    }

    // MARK: - BGM

    private func startBGM() {
        guard let url = Bundle.main.url(forResource: "magicSolo", withExtension: "mp3") else { return }
        bgmPlayer = try? AVAudioPlayer(contentsOf: url)
        bgmPlayer?.numberOfLoops = -1
        bgmPlayer?.volume = 1.0
        bgmPlayer?.play()
    }

    private func stopBGM() {
        bgmPlayer?.stop()
        bgmPlayer = nil
    }

    // MARK: - Hint timer

    private func startHintTimer() {
        removeAction(forKey: "hintTimer")
        let seq = SKAction.sequence([
            .wait(forDuration: 60),
            .run { [weak self] in self?.showHintIfNeeded() }
        ])
        run(.repeatForever(seq), withKey: "hintTimer")
    }

    private func showHintIfNeeded() {
        guard columnPieces.count == Layout.columnCount else { return }
        let order = (0..<Layout.columnCount).compactMap { columnPieces[$0]?.item }
        guard !PuzzlePatternData.correctSequences.contains(order) else { return }
        guard let piece = columnPieces.values.randomElement() else { return }
        showHintBubble(near: piece)
    }

    private func showHintBubble(near piece: PieceNode) {
        childNode(withName: "hintBubble")?.removeFromParent()

        let bubble = makeBubbleNode()
        bubble.name = "hintBubble"

        let preferredY = piece.position.y + piece.size.height / 2 + 53
        let bubbleHalfH: CGFloat = 45
        let margin: CGFloat = 16
        let clampedY = min(preferredY, size.height / 2 - bubbleHalfH - margin)

        bubble.position = CGPoint(x: piece.position.x, y: clampedY)
        bubble.alpha = 0
        addChild(bubble)

        bubble.run(.sequence([
            .fadeIn(withDuration: 0.25),
            .wait(forDuration: 3.5),
            .fadeOut(withDuration: 0.4),
            .removeFromParent()
        ]))
    }

    private func makeBubbleNode() -> SKNode {
        let container = SKNode()
        container.zPosition = 20

        let line1 = SKLabelNode(text: "I don't think this")
        line1.fontName                = "Sniglet-Regular"
        line1.fontSize                = 16
        line1.fontColor               = .white
        line1.horizontalAlignmentMode = .center
        line1.verticalAlignmentMode   = .center
        line1.position = CGPoint(x: 0, y: 14)
        container.addChild(line1)

        let line2 = SKLabelNode(text: "is quite right...")
        line2.fontName                = "Sniglet-Regular"
        line2.fontSize                = 16
        line2.fontColor               = .white
        line2.horizontalAlignmentMode = .center
        line2.verticalAlignmentMode   = .center
        line2.position = CGPoint(x: 0, y: -6)
        container.addChild(line2)

        let tail = SKLabelNode(text: "/")
        tail.fontName                = "Sniglet-Regular"
        tail.fontSize                = 20
        tail.fontColor               = .white
        tail.horizontalAlignmentMode = .center
        tail.verticalAlignmentMode   = .top
        tail.position = CGPoint(x: 0, y: -20)
        container.addChild(tail)

        return container
    }
}
