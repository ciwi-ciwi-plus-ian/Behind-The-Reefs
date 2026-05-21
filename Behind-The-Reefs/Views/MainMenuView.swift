//
//  MainMenuView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.

import SwiftUI
import SwiftData
import AVFoundation

struct MainMenuView: View {

    @Environment(NavigationRouter.self) private var router
    @Environment(\.modelContext) private var context
    @Query private var progressList: [GameProgress]

    @State private var showNewGameAlert = false
    @State private var showCredits = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var buttonSoundPlayer: AVAudioPlayer? 

    private var progress: GameProgress? { progressList.first }
    private var canContinue: Bool {
        guard let progress = progress else { return false }
        return !progress.isAllCompleted && (progress.hasStarted || !progress.completedPatterns.isEmpty)
    }

    private func playButtonSound() {
        guard let url = Bundle.main.url(
            forResource: "buttonSound",
            withExtension: "mp3"
        ) else { return }
        // ← simpan ke @State agar tidak langsung di-deallocate
        buttonSoundPlayer = try? AVAudioPlayer(contentsOf: url)
        buttonSoundPlayer?.play()
    }

    var body: some View {

        ZStack {

            Image("mainMenuBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Image("title")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 155)
                    .padding(.top, 50)
                Spacer()
            }

            VStack {
                Spacer()
                VStack(spacing: 10) {
                    Button {
                        playButtonSound()
                        if canContinue {
                            router.navigate(to: .puzzle)
                        }
                    } label: {
                        Image("continueButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    .disabled(!canContinue)
                    .opacity(canContinue ? 1 : 0.5)

                    Button {
                        playButtonSound()
                        if canContinue {
                            showNewGameAlert = true
                        } else {
                            resetProgressForNewGame()
                            router.navigate(to: .letter)
                        }
                    } label: {
                        Image("newGameButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }

                    Button {
                        playButtonSound()
                        showCredits = true
                    } label: {
                        Image("creditsButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                }
                .offset(y: 100)
                Spacer()
            }

            if showNewGameAlert {
                NewGameAlertView(
                    onDismiss: {
                        showNewGameAlert = false
                    },
                    onConfirm: {
                        showNewGameAlert = false
                        resetProgressForNewGame()
                        router.navigate(to: .letter)
                    }
                )
            }

            if showCredits {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()

                CreditsView(onDismiss: {
                    showCredits = false
                })
            }
        }
        .onAppear {
            playBGM()
        }
        .onDisappear {
            audioPlayer?.stop()
            audioPlayer = nil
        }
    }

    private func playBGM() {
        guard let url = Bundle.main.url(
            forResource: "mainMenuSound",
            withExtension: "mp3"
        ) else { return }

        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.volume = 0.7
        audioPlayer?.play()
    }

    private func resetProgressForNewGame() {
        for progress in progressList {
            context.delete(progress)
        }
        let newProgress = GameProgress()
        context.insert(newProgress)
        try? context.save()
    }
}

#Preview(traits: .landscapeRight) {
    MainMenuView()
        .environment(NavigationRouter())
}
