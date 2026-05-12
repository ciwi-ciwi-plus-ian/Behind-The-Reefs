//
//  KeyResultView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

struct KeyResultView: View {

    // Data yang diterima dari puzzle yang selesai
    var sortDescription: String  // contoh: "You've sorted the creatures by number of dots"
    var patternIndex: Int        // index pola yang baru selesai (0-4)

    // MARK: - Key Asset Names
    // Sesuaikan nama di sini kalau nama file aset berubah
    private let keyAssetNames = [
        "keyOne",   // index 0 — pola 1
        "keyTwo",   // index 1 — pola 2
        "keyThree", // index 2 — pola 3
        "keyFour",  // index 3 — pola 4
        "keyFive"   // index 4 — pola 5
    ]

    // Ambil nama aset kunci berdasarkan patternIndex dengan aman
    private var currentKeyAsset: String {
        guard patternIndex >= 0 && patternIndex < keyAssetNames.count else {
            return "keyOne" // fallback kalau index di luar range
        }
        return keyAssetNames[patternIndex]
    }

    var body: some View {
        ZStack {

            // MARK: - Background (digelapkan)
            Image("mainMenuBackground") // ← nama file background
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.55)
                )

            VStack(spacing: 32) {

                // MARK: - Sort Description Text
                Text(sortDescription)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 70)
                    .padding(.top, 50)
                

                // MARK: - Key Image
                Image(currentKeyAsset) // otomatis load keyOne/keyTwo/dst
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .scaleEffect(keyScale)
                    .opacity(keyOpacity)
                    .onAppear {
                        withAnimation(.spring(duration: 0.5, bounce: 0.4)) {
                            keyScale   = 1.0
                            keyOpacity = 1.0
                        }
                    }

                // MARK: - Finish Button
                Button {
                    // navigasi ke puzzle berikutnya — akan diisi saat routing siap
                } label: {
                    Image("btn_finish") // ← nama file aset tombol finish
                        .resizable()
                        .scaledToFit()
                        .frame(height: 56)
                }
            }

            // MARK: - Home Icon (pojok kiri atas)
            VStack {
                HStack {
                    Image("btn_home") // ← nama file aset tombol home
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .padding(16)
                    Spacer()
                }
                Spacer()
            }

            // MARK: - Chest Icon (pojok kanan atas)
            VStack {
                HStack {
                    Spacer()
                    Image("btn_chest") // ← nama file aset tombol chest
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .padding(16)
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Animation State
    @State private var keyScale:   CGFloat = 0.3
    @State private var keyOpacity: CGFloat = 0.0
}

// MARK: - Preview

#Preview (traits: .landscapeRight){
    KeyResultView(
        sortDescription: "You've sorted the creatures by number of dots",
        patternIndex: 0  // 0=keyOne, 1=keyTwo, 2=keyThree, 3=keyFour, 4=keyFive
    )
}
