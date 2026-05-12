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

    var body: some View {
        ZStack {

            // MARK: - Background (digelapkan)
            Image("mainMenuBackground") // ← nama file background
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    // Overlay gelap di atas background
                    Color.black.opacity(0.55)
                )

            VStack(spacing: 32) {

                // MARK: - Sort Description Text
                Text(sortDescription)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                // MARK: - Key Image
                Image("key_\(patternIndex + 1)") // ← nama file kunci sesuai index, contoh: key_1, key_2, dst
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    // Animasi kunci muncul — scale up dari kecil
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
        patternIndex: 4  // index 4 = key_5
    )
}
