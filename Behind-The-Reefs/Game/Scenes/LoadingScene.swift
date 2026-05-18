//
//  LoadingScene.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SpriteKit

class LoadingScene: SKScene {

    private var backgroundNode: SKSpriteNode?

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        setupBubbleParticles()
        setupAudio()
    }

    private func setupAudio() {
        let audio = SKAudioNode(fileNamed: "bubbleAudio")
        audio.autoplayLooped = true
        addChild(audio)
        self.audioNode = audio
    }

    private var audioNode: SKAudioNode?

    private func setupBubbleParticles() {
        let emitter = SKEmitterNode()

        emitter.particleTexture = SKTexture(imageNamed: "bubbleParticle")

        // Posisi emitter di bawah layar agar bubble naik dari bawah
        emitter.position = CGPoint(x: frame.midX, y: frame.minY - 20)
        emitter.zPosition = 2

        // Jumlah bubble per detik — naikkan untuk lebih padat
        emitter.particleBirthRate = 85

        // Durasi hidup setiap bubble
        emitter.particleLifetime = 1.0
        emitter.particleLifetimeRange = 1.0

        // Arah naik ke atas
        emitter.emissionAngle = .pi / 2   // 90 derajat = ke atas
        emitter.emissionAngleRange = 0.3  // sedikit variasi arah

        // Kecepatan naik
        emitter.particleSpeed = 1200
        emitter.particleSpeedRange = 60

        // Ukuran bubble
        emitter.particleScale = 0.20
        emitter.particleScaleRange = 0.1

        // Posisi spawn acak sepanjang lebar layar
        emitter.particlePositionRange = CGVector(
            dx: frame.width,
            dy: 0
        )

        // Transparansi — makin transparan saat naik
        emitter.particleAlpha = 0.7
        emitter.particleAlphaRange = 0.2
        emitter.particleAlphaSpeed = -0.15

        // Tidak ada gravitasi — bubble naik lurus
        emitter.yAcceleration = 0
        emitter.xAcceleration = 0

        addChild(emitter)
    }
    
    func stopAudio() {
            audioNode?.run(SKAction.stop())
            audioNode?.removeFromParent()
            audioNode = nil
        }

    override func willMove(from view: SKView) {
        audioNode?.run(SKAction.stop())
        audioNode?.removeFromParent()
        audioNode = nil
        removeAllActions()
        removeAllChildren()
    }
}
