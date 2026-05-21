import SwiftUI
import AVFoundation

struct LetterView: View {
    
    @Environment(NavigationRouter.self) private var router
    
    @State private var isOpened = false
    @State private var showOverlay = false
    @State private var showContent = false
    @State private var buttonSoundPlayer: AVAudioPlayer?

    private let snigletFont: Font = .custom("Sniglet-Regular", size: 16)
    private let textColor: Color = .white

    private let letterParagraphs: [String] = [
        "My dear descendant,",
        "If this letter has reached you, then you are ready. Beneath the ocean lies a place shaped by order and meaning, where nothing is random and everything must be set as it was meant to be.",
        "You will find scattered pieces, lost and misplaced. Your task is simple, though not easy. Every detail has a purpose and the path will reveal itself.",
        "Do not rush. Observe closely. The truth is not hidden. It is waiting to be put back together.",
        "Complete what I began.",
        "Reveal the truth."
    ]

    var body: some View {
        ZStack {
            Image(isOpened ? "letterFrameOpened" : "letterFrameClosed")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .offset(y: -1)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.4), value: isOpened)

            Color.black
                .opacity(showOverlay ? 0.8 : 0.0)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.6), value: showOverlay)

            VStack(alignment: .leading, spacing: 16) {
                ForEach(letterParagraphs, id: \.self) { paragraph in
                    Text(paragraph)
                        .font(snigletFont)
                        .multilineTextAlignment(.leading)
                }

                Button {
                    playSound()
                    router.navigate(to: .tutorial)
                } label: {
                    Text("Begin!")
                        .font(snigletFont)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.25))
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .foregroundColor(.white)
            .frame(maxWidth: 520, maxHeight: .infinity)
            .padding(.horizontal, 28)
            .ignoresSafeArea()
            .opacity(showContent ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.6), value: showContent)
        }
        .navigationBarHidden(!showContent)
        .onAppear {
            playletterSound()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isOpened = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showOverlay = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    showContent = true
                }
            }
        }
    }
    
    private func playletterSound() {
        guard let url = Bundle.main.url(
            forResource: "letterSound",
            withExtension: "mp3"
        ) else { return }
        buttonSoundPlayer = try? AVAudioPlayer(contentsOf: url)
        buttonSoundPlayer?.play()
        buttonSoundPlayer?.volume = 1.5
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(
            forResource: "buttonSound",
            withExtension: "mp3"
        ) else { return }
        buttonSoundPlayer = try? AVAudioPlayer(contentsOf: url)
        buttonSoundPlayer?.play()
    }
    
}

#Preview(traits: .landscapeRight) {
    LetterView()
        .environment(NavigationRouter())
}
