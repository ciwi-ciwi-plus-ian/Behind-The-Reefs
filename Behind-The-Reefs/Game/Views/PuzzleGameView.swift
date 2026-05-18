import SwiftUI
import SpriteKit
import SwiftData

struct PuzzleGameView: View {
    
    @Environment(NavigationRouter.self) private var router
    
    @Environment(\.modelContext) private var context

    @StateObject private var viewModel = PuzzleViewModel()
    
    // Fetch GameProgress dari SwiftData
        @Query private var progressList: [GameProgress]
        private var progress: GameProgress? { progressList.first }

        @State private var showCollection = false

    var body: some View {
        ZStack {
            background
            gameLayer
            navigationBar
            if viewModel.result == .correct {
                KeyResultView(
                    patternIndex: viewModel.matchedPatternIndex,
                    onContinue: {
                        progress?.completePattern(viewModel.matchedPatternIndex)
                                                try? context.save()
                        viewModel.resetPieces()
                    },
                    isAllCompleted: viewModel.isAllPatternsCompleted
                )
                .transition(.opacity.animation(.easeIn(duration: 0.3)))
            }
        }
        .ignoresSafeArea()
        .statusBarHidden()
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showCollection) {
                    CollectionView()
                        .environment(router)
                }
        .onAppear {
            if progressList.isEmpty {
                let newProgress = GameProgress()
                context.insert(newProgress)
                try? context.save()
            }
        }
    }

    private var background: some View {
        Image("PuzzleScreen")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }

    private var gameLayer: some View {
        SpriteView(scene: viewModel.scene, options: [.allowsTransparency])
            .ignoresSafeArea()
    }

    private var navigationBar: some View {
        VStack {
            HStack {
                Button {
                    router.goToMainMenu()
                } label: {
                    Image("homeIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                }
                .padding(.leading, 16)

                Spacer()

                Button {
                    showCollection = true
                } label: {
                    Image("treasureChestIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                }
                .padding(.trailing, 16)
            }
            .padding(.horizontal, 32)
            .padding(.top)
            Spacer()
        }
    }

    @ViewBuilder
    private func resultOverlay(_ result: PuzzleResult) -> some View {
        Color.black.opacity(0.55).ignoresSafeArea()

        VStack(spacing: 18) {
            Text("Correct!")
                .font(.custom("Sniglet-Regular", size: 32))
                .foregroundColor(.white)

            Text("You found a matching order!")
                .font(.custom("Sniglet-Regular", size: 17))
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)

            overlayButton("Continue", filled: true) {
                viewModel.resetPieces()
            }
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.05, green: 0.15, blue: 0.35).opacity(0.95))
        )
        .padding(.horizontal, 48)
    }

    private func overlayButton(_ label: String, filled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.custom("Sniglet-Regular", size: 19))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(filled ? Color.white.opacity(0.25) : Color.clear)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(0.4), lineWidth: 1.5))
        }
    }
}

#Preview(traits: .landscapeRight) {
    PuzzleGameView()
        .environment(NavigationRouter())
}
