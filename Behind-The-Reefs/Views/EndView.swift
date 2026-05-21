//
//  EndView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI
import AVFoundation

struct EndView: View {

    @Environment(NavigationRouter.self) private var router
    @State private var buttonSoundPlayer: AVAudioPlayer?
    @State private var bgmPlayer: AVAudioPlayer?
    @State private var showBubbles = false

    private let frameWidth:       CGFloat = 500
    private let frameHeight:      CGFloat = 300
    private let homeButtonWidth:  CGFloat = 100
    private let homeButtonHeight: CGFloat = 60
    
    private let bubbleConfigs: [Bubble] = [
        .init(id: 0, xOffset: -180, size: 0.40, delay: 0.0, duration: 9.0),
        .init(id: 1, xOffset: -90, size: 0.55, delay: 0.7, duration: 8.0),
        .init(id: 2, xOffset: -40, size: 0.70, delay: 0.4, duration: 10.0),
        .init(id: 3, xOffset: 60, size: 0.50, delay: 1.1, duration: 7.2),
        .init(id: 4, xOffset: 105, size: 0.65, delay: 0.6, duration: 8.5),
        .init(id: 5, xOffset: 170, size: 0.45, delay: 1.3, duration: 7.8),
        .init(id: 6, xOffset: -125, size: 0.65, delay: 2.6, duration: 8.5),
        .init(id: 7, xOffset: 175, size: 0.45, delay: 2.3, duration: 7.8),
        .init(id: 8, xOffset: -255, size: 0.65, delay: 1.6, duration: 8.2),
        .init(id: 9, xOffset: 255, size: 0.45, delay: 1.3, duration: 8.8)
    ]

    var body: some View {
        ZStack {

            Image("mainMenuBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.55))
                .navigationBarBackButtonHidden(true)

            ZStack {
                ForEach(bubbleConfigs) { config in
                    Image("bubbleParticle")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 90 * config.size,
                            height: 90 * config.size
                        )
                        .offset(
                            x: config.xOffset,
                            y: showBubbles ? -950 : 950
                        )
                        .animation(
                            Animation.linear(duration: config.duration)
                                .delay(config.delay)
                                .repeatForever(autoreverses: false),
                            value: showBubbles
                        )
                }

                Image("congratsFrame")
                    .resizable()
                    .scaledToFit()
                    .frame(width: frameWidth, height: frameHeight)

                VStack(spacing: 2) {

                    VStack(spacing: 1) {

                        Text("Every reef has a story,")
                            .font(.custom("Sniglet", size: 20))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 2)

                        Text("and now you've finished yours.")
                            .font(.custom("Sniglet", size: 20))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 2)

                        Text("Thank you for playing with us!")
                            .font(.custom("Sniglet", size: 20))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 2)
                    }
                    .padding(.top, 88)
                    .multilineTextAlignment(.center)

                    Button {
                        playSound()
                        router.goToMainMenu()
                    } label: {
                        Image("homeButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: homeButtonWidth, height: homeButtonHeight)
                    }
                    .padding(.top, 1)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            playEndingSound()
            HapticService.notification(.success)
            showBubbles = true
        }
        .onDisappear {
            bgmPlayer?.stop()
            bgmPlayer = nil
        }
    }

    private func playSound() {
        guard let url = Bundle.main.url(
            forResource: "buttonSound",
            withExtension: "mp3"
        ) else { return }
        buttonSoundPlayer = try? AVAudioPlayer(contentsOf: url)
        buttonSoundPlayer?.play()
    }

    private func playEndingSound() {
        guard let url = Bundle.main.url(
            forResource: "endingSound",
            withExtension: "mp3"
        ) else { return }
        bgmPlayer = try? AVAudioPlayer(contentsOf: url)
        bgmPlayer?.numberOfLoops = -1 
        bgmPlayer?.volume = 0.7
        bgmPlayer?.play()
    }
}

#Preview(traits: .landscapeRight) {
    EndView()
        .environment(NavigationRouter())
}
