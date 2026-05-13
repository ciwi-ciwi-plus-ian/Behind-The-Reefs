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

    // Cek apakah ini pola terakhir
    // true  → tampilkan finishButton saja
    // false → tampilkan homeButton + continueButton
    private var isLastPattern: Bool {
        patternIndex == 4
    }

    // MARK: - Button Size
    // Sesuaikan nilai ini untuk atur besar kecil button
    private let homeButtonWidth:     CGFloat = 100
    private let homeButtonHeight:    CGFloat = 60
    private let continueButtonWidth: CGFloat = 130
    private let continueButtonHeight: CGFloat = 60
    private let finishButtonWidth:   CGFloat = 130  // ← atur ukuran finishButton di sini
    private let finishButtonHeight:  CGFloat = 60

    // MARK: - Animation State
    @State private var keyScale:    CGFloat = 0.3
    @State private var keyOpacity:  CGFloat = 0.0
    @State private var glowOpacity: CGFloat = 0.3
    @State private var glowRadius:  CGFloat = 50

    var body: some View {
        ZStack {

            // MARK: - Background
            Image("mainMenuBackground") // ← nama file background
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

                    // Glow lingkaran kuning di belakang kunci
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
                        // Animasi glow berdenyut
                        .onAppear {
                            withAnimation(
                                .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                            ) {
                                glowOpacity = 0.8
                                glowRadius  = 80
                            }
                        }

                    // Gambar kunci
                    Image(currentKeyAsset)
                        .resizable()
                        .padding(.top, 30)
                        .scaledToFit()
                        .frame(height: 200)
                        .rotationEffect(.degrees(30))
                        .scaleEffect(keyScale)
                        .opacity(keyOpacity)
                        // Animasi kunci melayang naik turun
                        .offset(y: floatOffset)
                        .onAppear {
                            // Muncul dengan spring
                            withAnimation(.spring(duration: 0.5, bounce: 0.4)) {
                                keyScale   = 1.0
                                keyOpacity = 1.0
                            }
                            // Mulai animasi melayang setelah muncul
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
                // Tampilan button berbeda tergantung pola terakhir atau bukan
                if isLastPattern {

                    // Pola 5 (keyFive) — hanya tampilkan Finish button
                    Button {
                        // navigasi ke EndView — akan diisi saat routing siap
                    } label: {
                        Image("finishButton") // ← nama file aset tombol finish
                            .resizable()
                            .scaledToFit()
                            .frame(width: finishButtonWidth, height: finishButtonHeight)
                    }

                } else {

                    // Pola 1–4 — tampilkan Home + Continue button
                    HStack(spacing: 20) {

                        // Home Button
                        Button {
                            // navigasi ke main menu — akan diisi saat routing siap
                        } label: {
                            Image("homeButton") // ← nama file aset tombol home bawah
                                .resizable()
                                .scaledToFit()
                                .frame(width: homeButtonWidth, height: homeButtonHeight)
                        }

                        // Continue Button
                        Button {
                            // navigasi ke puzzle berikutnya — akan diisi saat routing siap
                        } label: {
                            Image("continueButton") // ← nama file aset tombol continue
                                .resizable()
                                .scaledToFit()
                                .frame(width: continueButtonWidth, height: continueButtonHeight)
                        }
                    }
                }
            }
            .padding(.horizontal, 40)

            // MARK: - Home Icon (pojok kiri atas)
            VStack {
                HStack {
                    Button {
                        // navigasi ke main menu — akan diisi saat routing siap
                    } label: {
                        Image("homeIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                    }
                    .padding(20)
                    Spacer()
                }
                Spacer()
            }

            // MARK: - Chest Icon (pojok kanan atas)
            VStack {
                HStack {
                    Spacer()
                    Button {
                        // buka collection view — akan diisi saat routing siap
                    } label: {
                        Image("treasureChestIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                    }
                    .padding(20)
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }

    // Float animation state — dipisah agar bisa diakses di onAppear
    @State private var floatOffset: CGFloat = 0
}

// MARK: - Preview

#Preview (traits: .landscapeRight){
    KeyResultView(
        sortDescription: "You've sorted the creatures by height",
        patternIndex: 0  // ganti ke 4 untuk test tampilan pola terakhir
    )
}
