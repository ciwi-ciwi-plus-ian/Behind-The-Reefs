//
//  KeyResultView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

struct KeyResultView: View {

    var sortDescription: String
    var patternIndex: Int

    // MARK: - Asset Names
    private let keyAssetNames = [
        "keyOne",   // index 0 — pola 1
        "keyTwo",   // index 1 — pola 2
        "keyThree", // index 2 — pola 3
        "keyFour",  // index 3 — pola 4
        "keyFive"   // index 4 — pola 5
    ]

    private var currentKeyAsset: String {
        guard patternIndex >= 0 && patternIndex < keyAssetNames.count else {
            return "keyOne"
        }
        return keyAssetNames[patternIndex]
    }

    private var isLastPattern: Bool {
        patternIndex == 4
    }

    // MARK: - Button Size
    private let homeButtonWidth:      CGFloat = 100
    private let homeButtonHeight:     CGFloat = 60
    private let continueButtonWidth:  CGFloat = 130
    private let continueButtonHeight: CGFloat = 60
    private let finishButtonWidth:    CGFloat = 130
    private let finishButtonHeight:   CGFloat = 60

    // MARK: - Animation State
    @State private var keyScale:    CGFloat = 0.3
    @State private var keyOpacity:  CGFloat = 0.0
    @State private var glowOpacity: CGFloat = 0.3
    @State private var glowRadius:  CGFloat = 50
    @State private var floatOffset: CGFloat = 0

    var body: some View {
        ZStack {

            // MARK: - Background
            Image("mainMenuBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.55))

            VStack(spacing: 0) {

                // MARK: - Sort Description Text
                Text(sortDescription)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 30)

                // MARK: - Key + Glow Effect
                ZStack {

                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.yellow.opacity(0.5),
                                    Color.yellow.opacity(0.2),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 10,
                                endRadius: glowRadius
                            )
                        )
                        .frame(width: glowRadius * 2.5, height: glowRadius * 2.5)
                        .opacity(glowOpacity)
                        .onAppear {
                            withAnimation(
                                .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                            ) {
                                glowOpacity = 0.8
                                glowRadius  = 80
                            }
                        }

                    Image(currentKeyAsset)
                        .resizable()
                        .padding(.top, 30)
                        .scaledToFit()
                        .frame(height: 200)
                        .rotationEffect(.degrees(30))
                        .scaleEffect(keyScale)
                        .opacity(keyOpacity)
                        .offset(y: floatOffset)
                        .onAppear {
                            withAnimation(.spring(duration: 0.5, bounce: 0.4)) {
                                keyScale   = 1.0
                                keyOpacity = 1.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(
                                    .easeInOut(duration: 1.8)
                                    .repeatForever(autoreverses: true)
                                ) {
                                    floatOffset = -12
                                }
                            }
                        }
                }
                .padding(.bottom, 32)

                // MARK: - Buttons Row
                if isLastPattern {
                    Button {
                        // navigasi ke EndView — akan diisi saat routing siap
                    } label: {
                        Image("finishButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: finishButtonWidth, height: finishButtonHeight)
                    }
                } else {
                    HStack(spacing: 20) {
                        Button {
                            // navigasi ke main menu — akan diisi saat routing siap
                        } label: {
                            Image("homeButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: homeButtonWidth, height: homeButtonHeight)
                        }

                        Button {
                            // navigasi ke puzzle berikutnya — akan diisi saat routing siap
                        } label: {
                            Image("continueButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: continueButtonWidth, height: continueButtonHeight)
                        }
                    }
                }
            }
            .padding(.horizontal, 40)

            // MARK: - Home Icon pojok kiri atas
            // Bukan button — hanya dekorasi dengan warna gelap mengikuti overlay
            VStack {
                HStack {
                    Image("homeIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .opacity(0.45) // ← sesuaikan nilai ini (0.0 = gelap total, 1.0 = normal)
                        .padding(20)
                    Spacer()
                }
                Spacer()
            }
            .allowsHitTesting(false) // ← tidak bisa diklik sama sekali

            // MARK: - Chest Icon pojok kanan atas
            // Bukan button — hanya dekorasi dengan warna gelap mengikuti overlay
            VStack {
                HStack {
                    Spacer()
                    Image("treasureChestIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .opacity(0.45) // ← sesuaikan nilai ini
                        .padding(20)
                }
                Spacer()
            }
            .allowsHitTesting(false) // ← tidak bisa diklik sama sekali
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Preview

#Preview(traits: .landscapeRight) {
    KeyResultView(
        sortDescription: "You've sorted the creatures by height",
        patternIndex: 0
    )
}
