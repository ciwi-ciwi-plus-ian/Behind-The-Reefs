import SwiftUI

private extension Font {
    static let snigletBody  = Font.custom("Sniglet-Regular", size: 15)
    static let snigletTitle = Font.custom("Sniglet-Regular", size: 17)
}

struct TutorialView: View {
    @State private var tutorialStep: Int = 1
    @Binding var isPresented: Bool

    private static let sortAreaWidth: CGFloat = 520

    var body: some View {
        GeometryReader { proxy in
            let sortRect = CGRect(
                x: (proxy.size.width - Self.sortAreaWidth) / 2,
                y: 0,
                width: Self.sortAreaWidth,
                height: proxy.size.height
            )
            ZStack {
                backgroundImage(size: proxy.size)
                overlayView(sortRect: sortRect)
                if tutorialStep >= 3 {
                    creatureItems(sortRect: sortRect, screenWidth: proxy.size.width)
                }
                navigationBar
                nextButton
                if tutorialStep < 4 { skipButton }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
        .onTapGesture { advance() }
    }

    private func backgroundImage(size: CGSize) -> some View {
        Image(tutorialStep < 3 ? "PuzzleScreen" : "PuzzleScreenWithPoints")
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipped()
            .ignoresSafeArea()
    }

    private var navigationBar: some View {
        VStack {
            HStack(alignment: .center) {
                Button { } label: {
                    Image("homeIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                }
                .padding(.leading, 16)
                .opacity(tutorialStep == 1 ? 1.0 : 0.3)

                if tutorialStep == 1 {
                    Text("Tap home to return\nto the main menu")
                        .font(.snigletBody)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 8)
                }

                Spacer()

                if tutorialStep == 2 {
                    Text("Tap here to view\nyour collected items")
                        .font(.snigletBody)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing, 8)
                }

                Button { } label: {
                    Image("treasureChestIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                }
                .padding(.trailing, 16)
                .opacity(tutorialStep == 2 ? 1.0 : 0.3)
            }
            .padding(.horizontal, 32)
            .padding()
            Spacer()
        }
    }

    private var nextButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: advance) {
                    Text(tutorialStep < 4 ? "Next" : "Got it!")
                        .font(.snigletTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 8)
                        .background(tutorialStep < 4 ? Color.white.opacity(0.25) : Color.black.opacity(0.55))
                        .clipShape(Capsule())
                }
                .padding()
                Spacer()
            }
        }
    }

    private var skipButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button { } label: {
                    Text("➜  Skip Tutorial")
                        .font(.snigletTitle)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 32)
            .padding()
        }
    }

    private func creatureItems(sortRect: CGRect, screenWidth: CGFloat) -> some View {
        let bottomY = sortRect.midY + 100
        let size: CGFloat = 80

        let chocoX: CGFloat  = tutorialStep == 3
            ? sortRect.minX / 2
            : sortRect.minX + sortRect.width * 0.25
        let purpleX: CGFloat = tutorialStep == 3
            ? sortRect.maxX + (screenWidth - sortRect.maxX) / 2
            : sortRect.minX + sortRect.width * 0.9

        return ZStack {
            creatureImage("itemChoco",  x: chocoX,  y: bottomY, size: size)
            creatureImage("itemPurple", x: purpleX, y: bottomY, size: size)
        }
    }

    private func creatureImage(_ name: String, x: CGFloat, y: CGFloat, size: CGFloat) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .position(x: x, y: y)
    }

    @ViewBuilder
    private func overlayView(sortRect: CGRect) -> some View {
        if tutorialStep >= 3 {
            ZStack {
                Color.black.opacity(0.75)
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: sortRect.width, height: sortRect.height)
                    .position(x: sortRect.midX, y: sortRect.midY)
                    .blendMode(.destinationOut)
                Text("Drag and drop\nyour items here")
                    .font(.snigletTitle)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: sortRect.width)
                    .position(x: sortRect.midX, y: sortRect.midY)
            }
            .compositingGroup()
            .ignoresSafeArea()
        } else {
            Color.black.opacity(0.75)
                .ignoresSafeArea()
        }
    }

    private func advance() {
        if tutorialStep < 4 { tutorialStep += 1 } else { isPresented = false }
    }
}

#Preview(traits: .landscapeRight) {
    TutorialView(isPresented: .constant(true))
}
