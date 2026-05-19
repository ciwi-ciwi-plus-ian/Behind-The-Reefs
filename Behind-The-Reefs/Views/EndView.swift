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

    private let frameWidth:       CGFloat = 500
    private let frameHeight:      CGFloat = 300
    private let homeButtonWidth:  CGFloat = 100
    private let homeButtonHeight: CGFloat = 60

    var body: some View {
        ZStack {

            // MARK: - Background
            Image("mainMenuBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.55))
                .navigationBarBackButtonHidden(true)

            ZStack {

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
    EndView()
        .environment(NavigationRouter())
}
