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

    // MARK: - Setup

    override func didMove(to view: SKView) {
        setupBackground()
        setupBubbleParticles()
        setupAudio()
    }

    // MARK: - Audio

    private func setupAudio() {
        let audio = SKAudioNode(fileNamed: "bubbleAudio") // ganti sesuai nama file MP3 kalian
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

        // Mulai dari gelap lalu fade in
        background.alpha = 0
        background.run(SKAction.fadeIn(withDuration: 0.8))
    }

    // MARK: - Bubble Particles
    // Langsung pakai PNG asset tanpa file .sks

    private func setupBubbleParticles() {
        let emitter = SKEmitterNode()

        // Set texture langsung dari PNG asset
        // Ganti "bubbleParticle" dengan nama PNG kalian di xcassets
        emitter.particleTexture = SKTexture(imageNamed: "bubbleParticle")

        // Posisi emitter di bawah layar agar bubble naik dari bawah
        emitter.position = CGPoint(x: frame.midX, y: frame.minY - 20)
        emitter.zPosition = 2

        // Jumlah bubble per detik — naikkan untuk lebih padat
        emitter.particleBirthRate = 50

        // Durasi hidup setiap bubble
        emitter.particleLifetime = 1.0
        emitter.particleLifetimeRange = 1.0

        // Arah naik ke atas
        emitter.emissionAngle = .pi / 2   // 90 derajat = ke atas
        emitter.emissionAngleRange = 0.3  // sedikit variasi arah

        // Kecepatan naik
        emitter.particleSpeed = 500
        emitter.particleSpeedRange = 60

        // Ukuran bubble
        emitter.particleScale = 0.15
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

    // MARK: - Cleanup
    // SKAudioNode otomatis berhenti saat scene di-dismiss

    override func willMove(from view: SKView) {
        removeAllActions()
        removeAllChildren()
    }
}
