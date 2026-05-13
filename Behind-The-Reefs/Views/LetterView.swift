import SwiftUI

struct LetterView: View {
    @State private var isOpened = false
    @State private var showOverlay = false
    @State private var showContent = false

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
            Image(isOpened ? "letterFrameOne" : "letterFrameTwo")
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
                        .font(.system(size: 14, weight: .regular, design: .serif))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                }

                Button(action: {}) {
                    Text("Begin!")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                        .background(Color(white: 0.85))
                        .clipShape(Capsule())
                }
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: 520, maxHeight: .infinity)
            .padding(.horizontal, 28)
            .ignoresSafeArea()
            .opacity(showContent ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.6), value: showContent)
        }
        .onAppear {
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
}

#Preview(traits: .landscapeRight) {
    LetterView()
}
