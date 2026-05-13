import SpriteKit

// Invisible hit-zone for one column in the sorting area.
final class SlotNode: SKShapeNode {

    let columnIndex: Int

    init(columnIndex: Int, rect: CGRect) {
        self.columnIndex = columnIndex
        super.init()
        path        = UIBezierPath(roundedRect: rect, cornerRadius: 10).cgPath
        strokeColor = .clear
        fillColor   = .clear
        lineWidth   = 0
        zPosition   = 0
        name        = "slot_\(columnIndex)"
    }

    required init?(coder: NSCoder) { fatalError() }

    func setHighlighted(_ on: Bool) { }
}
