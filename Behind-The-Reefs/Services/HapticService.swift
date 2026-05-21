import UIKit
import CoreHaptics

enum HapticService {

    // MARK: - Standard tap (soft 0.5) — dipakai di semua drag/drop puzzle & tutorial
    static func tap() {
        let gen = UIImpactFeedbackGenerator(style: .soft)
        gen.prepare()
        gen.impactOccurred(intensity: 0.5)
    }

    // MARK: - Single impact
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle, intensity: CGFloat = 1.0) {
        let gen = UIImpactFeedbackGenerator(style: style)
        gen.prepare()
        gen.impactOccurred(intensity: intensity)
    }

    // MARK: - Notification
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let gen = UINotificationFeedbackGenerator()
        gen.prepare()
        gen.notificationOccurred(type)
    }

    // MARK: - Prolonged continuous haptic (CoreHaptics)
    // Dipakai untuk chest open agar getarannya terasa lebih panjang
    private static var engine: CHHapticEngine?
    private static var player: CHHapticPatternPlayer?

    static func prolonged(duration: TimeInterval = 0.8, intensity: Float = 1.0, sharpness: Float = 0.5) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            let eng = try CHHapticEngine()
            engine = eng
            try eng.start()

            eng.stoppedHandler = { _ in engine = nil; player = nil }
            eng.resetHandler   = { engine = nil; player = nil }

            let intensityParam = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
            let sharpnessParam = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)

            let event = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [intensityParam, sharpnessParam],
                relativeTime: 0,
                duration: duration
            )

            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let p = try eng.makePlayer(with: pattern)
            player = p
            try p.start(atTime: CHHapticTimeImmediate)
        } catch {
            // Fallback ke single heavy impact jika CoreHaptics gagal
            impact(.heavy)
        }
    }
}
