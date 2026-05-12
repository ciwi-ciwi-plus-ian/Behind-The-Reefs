//
//  LoadingScene.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SpriteKit

class LoadingScene: SKScene {

    // MARK: - Nodes
    private var backgroundNode: SKSpriteNode?
    private var bubbleEmitter: SKEmitterNode?
    private var loadingLabel: SKLabelNode?

    // MARK: - Setup

    override func didMove(to view: SKView) {
        setupBackground()
        setupBubbleParticles()
        setupAudio()             // ← tambahan
    }

    // MARK: - Audio

    private func setupAudio() {
        let audio = SKAudioNode(fileNamed: "bubbleAudio")
        audio.autoplayLooped = true
        addChild(audio)
    }

    // MARK: - Background

    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "bubbleBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = frame.size
        background.zPosition = 0
        addChild(background)
        self.backgroundNode = background

        background.alpha = 0
        let fadeIn = SKAction.fadeIn(withDuration: 0.8)
        background.run(fadeIn)
    }

    // MARK: - Bubble Particles

    private func setupBubbleParticles() {
        guard let emitter = SKEmitterNode(fileNamed: "bubbleParticle") else {
            setupManualBubbles()
            return
        }

        emitter.position = CGPoint(x: frame.midX, y: frame.minY - 20)
        emitter.zPosition = 2
        addChild(emitter)
    }

    // MARK: - Manual Bubbles

    private func setupManualBubbles() {
        for _ in 0..<30 {
            spawnInitialBubble()
        }

        let spawnAction = SKAction.run { [weak self] in
            self?.spawnOneBubble()
        }
        let wait     = SKAction.wait(forDuration: 0.08)
        let sequence = SKAction.sequence([spawnAction, wait])
        run(SKAction.repeatForever(sequence), withKey: "spawnBubbles")
    }

    private func spawnInitialBubble() {
        let size   = CGFloat.random(in: 8...35)
        let bubble = makeBubbleNode(size: size)

        let randomX = CGFloat.random(in: frame.minX...frame.maxX)
        let randomY = CGFloat.random(in: frame.minY...frame.maxY)
        bubble.position = CGPoint(x: randomX, y: randomY)
        addChild(bubble)

        animateBubble(bubble, size: size)
    }

    private func spawnOneBubble() {
        let size   = CGFloat.random(in: 6...32)
        let bubble = makeBubbleNode(size: size)

        let randomX = CGFloat.random(in: frame.minX...frame.maxX)
        bubble.position = CGPoint(x: randomX, y: frame.minY - size)
        addChild(bubble)

        animateBubble(bubble, size: size)
    }

    // MARK: - Bubble Factory

    private func makeBubbleNode(size: CGFloat) -> SKShapeNode {
        let bubble = SKShapeNode(circleOfRadius: size)

        let isLight = Bool.random()
        if isLight {
            bubble.fillColor   = UIColor(white: 1.0, alpha: CGFloat.random(in: 0.15...0.35))
            bubble.strokeColor = UIColor(white: 1.0, alpha: CGFloat.random(in: 0.4...0.7))
        } else {
            bubble.fillColor   = UIColor(red: 0.6, green: 0.85, blue: 1.0,
                                         alpha: CGFloat.random(in: 0.2...0.4))
            bubble.strokeColor = UIColor(red: 0.75, green: 0.92, blue: 1.0,
                                         alpha: CGFloat.random(in: 0.5...0.8))
        }

        bubble.lineWidth = CGFloat.random(in: 0.8...2.0)
        bubble.zPosition = CGFloat.random(in: 1...3)

        return bubble
    }

    // MARK: - Bubble Animation

    private func animateBubble(_ bubble: SKShapeNode, size: CGFloat) {
        let duration = Double.random(in: 1.8...4.0)

        let moveUp  = SKAction.moveBy(
                        x: CGFloat.random(in: -40...40),
                        y: frame.height + size * 2,
                        duration: duration)

        let scaleUp = SKAction.scale(
                        to: CGFloat.random(in: 1.1...1.4),
                        duration: duration)

        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let remove  = SKAction.removeFromParent()

        let floating = SKAction.group([moveUp, scaleUp])
        bubble.run(SKAction.sequence([floating, fadeOut, remove]))
    }

    // MARK: - Cleanup
    // SKAudioNode otomatis berhenti saat scene di-dismiss
    // tidak perlu manual stop

    override func willMove(from view: SKView) {
        removeAllActions()
        removeAllChildren()
    }
}
