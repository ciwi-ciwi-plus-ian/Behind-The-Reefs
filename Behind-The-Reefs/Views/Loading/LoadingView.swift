import SpriteKit
import SwiftUI

class LoadingScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.05, green: 0.3, blue: 0.6, alpha: 1.0)
        addLoadingText()
        createBubbleParticles()
    }
    
    private func createBubbleParticles() {
        let emitter = SKEmitterNode()
        
        emitter.particleTexture = SKTexture(imageNamed: "waterBubble")
        emitter.position = CGPoint(x: size.width / 2, y: -20)
        emitter.particlePositionRange = CGVector(dx: size.width, dy: 0)
        
        emitter.emissionAngle = .pi / 2
        emitter.emissionAngleRange = .pi / 14  // Rapat ke tengah
        emitter.particleSpeed = 55
        emitter.particleSpeedRange = 10
        emitter.particleBirthRate = 55
        
        emitter.particleLifetime = 14.0
        emitter.particleLifetimeRange = 3.0
        
        emitter.particleScale = 0.08
        emitter.particleScaleRange = 0.06
        emitter.particleScaleSpeed = 0.003
        
        emitter.particleAlpha = 0.75
        emitter.particleAlphaRange = 0.2
        emitter.particleAlphaSpeed = 0
        
        emitter.particleBlendMode = .alpha
        emitter.zPosition = 1
        emitter.advanceSimulationTime(14.0)
        
        addChild(emitter)
    }
    
    private func addLoadingText() {
        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = "LOADING..."
        label.fontSize = 28
        label.fontColor = .white
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        label.zPosition = 10
        
        let pulse = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.8),
            SKAction.fadeAlpha(to: 1.0, duration: 0.8)
        ])
        label.run(SKAction.repeatForever(pulse))
        addChild(label)
    }
}

#Preview(traits: .landscapeRight) {
    let size = CGSize(width: 393, height: 852)
    let scene = LoadingScene(size: size)
    scene.scaleMode = .aspectFill
    return SpriteView(scene: scene)
        .ignoresSafeArea()
}
