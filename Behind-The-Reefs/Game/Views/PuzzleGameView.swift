import SwiftUI
import SpriteKit
import SwiftData
import AVFoundation

struct PuzzleGameView: View {
    
    @Environment(NavigationRouter.self) private var router
    
    @Environment(\.modelContext) private var context

    @StateObject private var viewModel = PuzzleViewModel()
    
    
    @Query private var progressList: [GameProgress]
    private var progress: GameProgress? { progressList.first }

    @State private var showCollection = false
    @State private var showLoading = true
    @State private var buttonSoundPlayer: AVAudioPlayer?

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
                        viewModel.dismissResult()
                    },
                    isAllCompleted: viewModel.isAllPatternsCompleted
                )
                .transition(.opacity.animation(.easeIn(duration: 0.3)))
            }
            if showLoading {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                    .zIndex(20)
                LoadingGameView()
                    .zIndex(21)
                    .transition(.opacity)
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
            if let progress = progress {
                if !progress.hasStarted {
                    progress.hasStarted = true
                    try? context.save()
                }
                viewModel.completedPatterns = Set(progress.completedPatterns)
                if let lastSolvedIndex = progress.lastSolvedPatternIndex {
                    viewModel.previousPatternIndex = lastSolvedIndex
                }
            } else {
                let newProgress = GameProgress()
                newProgress.hasStarted = true
                context.insert(newProgress)
                try? context.save()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                withAnimation(.easeOut(duration: 0.3)) {
                    showLoading = false
                }
            }
        }
        
        .onDisappear {
            AudioManager.shared.stopBGM()
            viewModel.scene.stopBGM()
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
                    playButtonSound()
                    router.goToMainMenu()
                } label: {
                    Image("homeIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 46, height: 46)
                }
                .padding(.leading, 16)

                Spacer()

                Button {
                    playButtonSound()
                    showCollection = true
                } label: {
                    Image("treasureChestIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 46, height: 46)
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
                viewModel.dismissResult()
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
    
    private func playButtonSound() {
        guard let url = Bundle.main.url(
            forResource: "buttonSound",
            withExtension: "mp3"
        ) else { return }
        buttonSoundPlayer = try? AVAudioPlayer(contentsOf: url)
        buttonSoundPlayer?.play()
    }
}

#Preview(traits: .landscapeRight) {
    PuzzleGameView()
        .environment(NavigationRouter())
}
