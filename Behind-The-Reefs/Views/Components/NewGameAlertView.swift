//
//  NewGameAlertView.swift
//  Behind-The-Reefs
//
//  Created by Bryan Samuel on 12/05/26.
//

import SwiftUI
import AVFoundation

struct NewGameAlertView: View {

    var onDismiss: (() -> Void)?
    var onConfirm: (() -> Void)?

    @State private var buttonSoundPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()

            ZStack {

                VStack(spacing: 0) {
                    Text("Start Again?")
                        .font(.custom("Chewy-Regular", size: 32))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
                        .padding(.top, 10)

                    Rectangle()
                        .fill(Color.white.opacity(0.8))
                        .frame(height: 4)
                        .padding(.horizontal, 60)
                        .overlay(
                            Rectangle()
                                .fill(Color.black.opacity(0.25))
                                .frame(height: 1)
                                .offset(y: 2)
                                .padding(.horizontal, 60)
                        )
                        .padding(.vertical, 20)

                    VStack(spacing: 3) {
                        Text("Are you sure want to start a new game?")
                            .font(.custom("Sniglet-Regular", size: 18))
                            .foregroundColor(.white)
                        Text("Past progress will be deleted!")
                            .font(.custom("Sniglet-Regular", size: 18))
                            .foregroundColor(.white)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 15)

                    HStack(spacing: 15) {
                        Button {
                            playSound()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {  // ← delay 0.3 detik
                                    onDismiss?()
                                }
                            onDismiss?()
                        } label: {
                            Image("noCancel")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 35)
                        }

                        Button {
                            playSound()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {  // ← delay 0.3 detik
                                    onDismiss?()
                                }
                            onConfirm?()
                        } label: {
                            Image("yesNewGame")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 35)
                        }
                    }
                    .padding(.bottom, 15)
                }
            }
            .padding(20)
            .frame(width: 500, height: 300)
            .background(
                Image("frame")
                    .resizable()
                    .scaledToFit()
            )
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(radius: 10)
        }
    }

    private func playSound() {
        guard let url = Bundle.main.url(
            forResource: "exitSound",
            withExtension: "mp3"
        ) else { return }
        buttonSoundPlayer = try? AVAudioPlayer(contentsOf: url)
        buttonSoundPlayer?.play()
    }
}

struct NewGameAlertView_Previews: PreviewProvider {
    static var previews: some View {
        NewGameAlertView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
