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

    private var stoneNode:    SKSpriteNode?
    private var starFishNode: SKSpriteNode?
    private var starfishVisiblePosition: CGPoint = .zero
    private var starfishHiddenPosition:  CGPoint = .zero
    private var isStarFishShowing = false

    private var bgmPlayer: AVAudioPlayer?
    var onAnswerChecked: ((Int) -> Void)?
    var onWrongAnswer: (() -> Void)?

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        anchorPoint     = CGPoint(x: 0.5, y: 0.5)
        setupSlots()
        setupPieces()
        setupStarFish()
        showIntroMessage()
        startHintTimer()
        startBGM()
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
        HapticService.tap()
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
        piece.restartIdleAnimation()

        guard !cancelled, let targetCol = targetColumn(for: piece.position.x) else { return }

        if let occupant = columnPieces[targetCol], occupant !== piece {
            columnPieces.removeValue(forKey: targetCol)

            if let sourceCol = dragSourceColumn {
                // slot-to-slot swap
                HapticService.tap()
                columnPieces[sourceCol] = occupant
                occupant.snapToColumn(sourceCol, at: CGPoint(x: columnCenterX(at: sourceCol), y: occupant.position.y))
            } else {
                // piece from pool displaces occupant to outer pool
                HapticService.tap()
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
        if dragSourceColumn != targetCol {
            HapticService.tap()
        }

        if columnPieces.count == Layout.columnCount {
            checkAnswer()
        }
    }

    func checkAnswer() {
        let order = (0..<Layout.columnCount).compactMap { columnPieces[$0]?.item }
        guard order.count == Layout.columnCount else { return }

        guard let matchedIndex = PuzzlePatternData.all.firstIndex(where: {
            $0.correctOrder == order
        }) else { return }

        HapticService.notification(.success)
        onAnswerChecked?(matchedIndex)
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

    func stopBGM() {
        bgmPlayer?.stop()
        bgmPlayer = nil
    }

    // MARK: - Starfish character

    private func setupStarFish() {
        let stone = SKSpriteNode(imageNamed: "stoneStarFish")
        stone.setScale(0.15)
        stone.anchorPoint = CGPoint(x: 1, y: 0)
        stone.zPosition = 6
        stone.position = CGPoint(x: size.width / 2, y: -size.height / 2)
        stone.alpha = 0
        addChild(stone)
        stoneNode = stone

        let sf = SKSpriteNode(imageNamed: "starFish")
        sf.setScale(0.2)
        sf.zPosition = 5
        sf.name = "starFishCharacter"
        sf.anchorPoint = CGPoint(x: 1, y: 0)

        let visibleX = stone.position.x + 25
        let visibleY = stone.position.y - 50
        starfishVisiblePosition = CGPoint(x: visibleX, y: visibleY)
        starfishHiddenPosition  = CGPoint(x: visibleX, y: visibleY - sf.size.height - 40)

        sf.position = starfishHiddenPosition
        sf.alpha = 0
        addChild(sf)
        starFishNode = sf
    }

    private func showStarFish(duration: TimeInterval = 3.0, then completion: (() -> Void)? = nil) {
        guard let sf = starFishNode, let stone = stoneNode, !isStarFishShowing else { return }
        isStarFishShowing = true

        stone.removeAction(forKey: "hideStone")
        sf.removeAllActions()
        sf.position = starfishHiddenPosition
        sf.alpha = 0

        stone.run(.fadeIn(withDuration: 0.4)) { [weak self] in
            guard let self else { return }
            let appear = SKAction.group([
                SKAction.fadeIn(withDuration: duration),
                SKAction.move(to: self.starfishVisiblePosition, duration: duration)
            ])
            appear.timingMode = .easeOut
            sf.run(appear) { completion?() }
        }
    }

    private func hideStarFish(delay: TimeInterval = 0) {
        guard let sf = starFishNode, let stone = stoneNode else { return }
        let disappear = SKAction.sequence([
            .wait(forDuration: delay),
            .group([
                .fadeOut(withDuration: 0.5),
                .move(to: starfishHiddenPosition, duration: 0.5)
            ]),
            .run { [weak self] in
                self?.isStarFishShowing = false
                stone.run(.fadeOut(withDuration: 0.4), withKey: "hideStone")
            }
        ])
        sf.run(disappear, withKey: "hideStarFish")
    }

    private func showIntroMessage() {
        showStarFish(duration: 1.0) { [weak self] in
            self?.showHintBubble(text: "Every detail of each creature serves a purpose…", bubbleDuration: 8.0)
            self?.hideStarFish(delay: 10.0)
        }
    }

    // MARK: - Hint timer

    private func startHintTimer() {
        removeAction(forKey: "hintTimer")
        let seq = SKAction.sequence([
            .wait(forDuration: 20),
            .run { [weak self] in self?.showHintIfNeeded() }
        ])
        run(.repeatForever(seq), withKey: "hintTimer")
    }

    // MARK: - Hint text content

    private static let hintMessages: [String] = [
        "I don't think this is right...",
        "Something feels off here...",
        "Something isn't adding up…",
        "Something about this bothers me…",
        "I feel like we're missing something…",
        "There's more to this than it seems…",
    ]

    // MARK: - Hint display

    private func showHintIfNeeded() {
        if columnPieces.count == Layout.columnCount {
            let order = (0..<Layout.columnCount).compactMap { columnPieces[$0]?.item }
            if PuzzlePatternData.correctSequences.contains(order) { return }
        }
        let text = Self.hintMessages.randomElement() ?? Self.hintMessages[0]
        showStarFish(duration: 3.0) { [weak self] in
            self?.showHintBubble(text: text, bubbleDuration: 4.0)
            self?.hideStarFish(delay: 5.0)
        }
    }

    private func showHintBubble(text: String, bubbleDuration: TimeInterval = 4.0) {
        childNode(withName: "hintBubble")?.removeFromParent()
        guard let sf = starFishNode else { return }

        let (bubble, bubbleSize) = makeBubbleNode(text: text)
        bubble.name = "hintBubble"

        bubble.position = CGPoint(
            x: sf.position.x - sf.size.width - 50,
            y: sf.position.y + sf.size.height / 2 + bubbleSize.height / 2 + 8
        )
        bubble.alpha = 0
        addChild(bubble)

        bubble.run(.sequence([
            .fadeIn(withDuration: 0.25),
            .wait(forDuration: bubbleDuration),
            .fadeOut(withDuration: 0.4),
            .removeFromParent()
        ]))
    }

    // MARK: - Bubble visual builder

    private func makeBubbleNode(text: String, maxWidth: CGFloat = 220) -> (SKNode, CGSize) {
        let container    = SKNode()
        container.zPosition = 20

        let fontSize:     CGFloat = 14
        let paddingH:     CGFloat = 16
        let paddingV:     CGFloat = 12
        let cornerRadius: CGFloat = 14

        let label = SKLabelNode(text: text)
        label.fontName                = "Sniglet-Regular"
        label.fontSize                = fontSize
        label.fontColor               = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1)
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode   = .center
        label.numberOfLines           = 0
        label.preferredMaxLayoutWidth = maxWidth - paddingH * 2

        let textSize = label.frame.size
        let bubbleW  = min(textSize.width + paddingH * 2, maxWidth)
        let bubbleH  = textSize.height + paddingV * 2

        let rect = CGRect(x: -bubbleW / 2, y: -bubbleH / 2, width: bubbleW, height: bubbleH)
        let background = SKShapeNode(rect: rect, cornerRadius: cornerRadius)
        background.fillColor   = .white
        background.strokeColor = .clear
        container.addChild(background)

        let tailPath = UIBezierPath()
        tailPath.move(to:    CGPoint(x: bubbleW / 2 - 34, y: -bubbleH / 2 + 8))
        tailPath.addLine(to: CGPoint(x: bubbleW / 2 +  2, y: -bubbleH / 2 - 6))
        tailPath.addLine(to: CGPoint(x: bubbleW / 2 - 10, y: -bubbleH / 2 + 11))
        tailPath.close()
        let tail = SKShapeNode(path: tailPath.cgPath)
        tail.fillColor   = .white
        tail.strokeColor = .clear
        container.addChild(tail)

        label.position = .zero
        container.addChild(label)

        return (container, CGSize(width: bubbleW, height: bubbleH))
    }
    
    override func willMove(from view: SKView) {
        stopBGM()
        removeAllActions()
        removeAllChildren()
    }
}
