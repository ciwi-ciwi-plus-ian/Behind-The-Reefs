//
//  KeyResultView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

struct KeyResultView: View {

    var patternIndex: Int

    // MARK: - Asset Names
    private let keyAssetNames = [
        "keyOne",
        "keyTwo",
        "keyThree",
        "keyFour",
        "keyFive"
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

    // MARK: - Animation State
    @State private var keyScale:    CGFloat = 0.3
    @State private var keyOpacity:  CGFloat = 0.0
    @State private var glowOpacity: CGFloat = 0.3
    @State private var glowRadius:  CGFloat = 50
    @State private var floatOffset: CGFloat = 0

    var body: some View {
        ZStack {

            Color.black.opacity(0.55)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                Text("You've sorted the creatures by height")
                    .font(.custom("Sniglet-Regular", size: 26))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 30)

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

                if isLastPattern {
                    Button {
                        // navigasi ke EndView — akan diisi saat routing siap
                    } label: {
                        Image("finishButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 45)
                    }
                } else {
                    HStack(spacing: 15) {
                        Button {
                            // navigasi ke main menu — akan diisi saat routing siap
                        } label: {
                            Image("homeButton")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 45)
                        }

                        Button {
                            // navigasi ke puzzle berikutnya — akan diisi saat routing siap
                        } label: {
                            Image("continueButton")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 45)
                        }
                    }
                }
            }
            .padding(.horizontal, 40)
        }
        .navigationBarHidden(true)
    }
}

#Preview(traits: .landscapeRight) {
    KeyResultView(
        patternIndex: 0
    )
}
