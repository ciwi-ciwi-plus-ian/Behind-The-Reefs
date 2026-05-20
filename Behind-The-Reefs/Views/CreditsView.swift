//
//  CreditsView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI
import AVFoundation

struct CreditsView: View {

    var onDismiss: (() -> Void)?

    @State private var buttonSoundPlayer: AVAudioPlayer?

    var body: some View {

        ZStack {

            VStack {
                HStack {
                    Spacer()
                    Button {
                        playSound()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {  // ← delay 0.3 detik
                                onDismiss?()
                            }
                        onDismiss?()
                    } label: {
                        Image("exitButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .padding(35)
                            .padding(.trailing, -20)
                    }
                }
                Spacer()

                Text("Made with dedication by Behind the Reefs team")
                    .font(Font.custom("Sniglet-Regular", size: 9))
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))

                Text("© 2026 Behind the Reefs. All rights reserved.")
                    .font(Font.custom("Sniglet-Regular", size: 9))
                    .padding(.bottom, -15)
                    .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
            }

            ZStack {
                VStack {
                    Spacer()
                    Spacer()
                        .frame(width: 500, height: 350)
                        .background(
                            Image("frame")
                                .resizable()
                                .scaledToFit()
                                .padding(.top, 25)
                        )
                }
                ZStack {
                    VStack {
                        Text("Behind The Reefs")
                            .font(Font.custom("Sniglet-Regular", size: 30))
                            .foregroundColor(Color.white)
                            .padding(.bottom, -10)
                            .padding(.top, 15)

                        Text("CREDITS")
                            .font(Font.custom("Sniglet-Regular", size: 15))
                            .foregroundColor(Color.white)

                        Rectangle()
                            .fill(Color.white.opacity(0.8))
                            .frame(width: 380, height: 3)
                            .padding(.horizontal, 40)
                            .padding(.top, -5)

                        HStack {
                            Text("Project Manager")
                                .font(Font.custom("Sniglet-Regular", size: 17))
                                .foregroundColor(Color.white)
                                .padding(.trailing, 135)
                            Text("Ivana Grasielda")
                                .font(Font.custom("Sniglet-Regular", size: 17))
                                .foregroundColor(Color.white)
                        }
                        .padding(.top, -5)

                        HStack {
                            Text("Programmer 1")
                                .font(Font.custom("Sniglet-Regular", size: 17))
                                .foregroundColor(Color.white)
                                .padding(.trailing, 163)
                            Text("Bryan Samuel")
                                .font(Font.custom("Sniglet-Regular", size: 17))
                                .foregroundColor(Color.white)
                        }

                        HStack {
                            Text("Programmer 2")
                                .font(Font.custom("Sniglet-Regular", size: 17))
                                .foregroundColor(Color.white)
                                .padding(.trailing, 168)
                            Text("Ivone Liwang")
                                .font(Font.custom("Sniglet-Regular", size: 17))
                                .foregroundColor(Color.white)
                        }

                        HStack {
                            Text("Programmer 3")
                                .font(Font.custom("Sniglet-Regular", size: 17))
                                .foregroundColor(Color.white)
                                .padding(.trailing, 155)
                                .padding(.leading, -10)
                            Text("Hana Azizah N.")
                                .font(Font.custom("Sniglet-Regular", size: 17))
                                .foregroundColor(Color.white)
                                .padding(.trailing, -10)
                        }

                        HStack {
                            Text("Art & Design")
                                .font(Font.custom("Sniglet-Regular", size: 17))
                                .foregroundColor(Color.white)
                                .padding(.trailing, 145)
                                .padding(.leading, -7)
                            Text("Angely Georgina J.")
                                .font(Font.custom("Sniglet-Regular", size: 17))
                                .foregroundColor(Color.white)
                                .padding(.trailing, -10)
                        }
                        .padding(.bottom, 10)

                        Text("Special Thanks to Our Mentor")
                            .font(Font.custom("Sniglet-Regular", size: 15))
                            .foregroundColor(Color.white)
                            .padding(.bottom, -9)

                        Text("Amelia Alexandra")
                            .font(Font.custom("Sniglet-Regular", size: 17))
                            .foregroundColor(Color.white)
                    }
                }
            }
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

#Preview(traits: .landscapeRight) {
    CreditsView()
}
