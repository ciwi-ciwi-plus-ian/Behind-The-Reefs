//
//  EndView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

struct EndView: View {

    // MARK: - Size
    // Sesuaikan nilai ini untuk atur besar kecil elemen
    private let frameWidth:       CGFloat = 500  // ← atur lebar frame kayu
    private let frameHeight:      CGFloat = 300  // ← atur tinggi frame kayu
    private let homeButtonWidth:  CGFloat = 100
    private let homeButtonHeight: CGFloat = 60

    var body: some View {
        ZStack {

            // MARK: - Background
            Image("mainMenuBackground") // ← nama file background
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.55))

            // MARK: - Frame kayu + konten di dalamnya
            ZStack {

                // Aset frame kayu sebagai background card
                Image("frame") // ← nama file aset frame kayu
                    .resizable()
                    .scaledToFit()
                    .frame(width: frameWidth, height: frameHeight)

                // Konten di atas frame
                VStack(spacing: 24) {

                    // MARK: - Teks Congratulations
                    VStack(spacing: 6) {
                        Text("Congratulations!")
                            .font(.custom("Chewy", size: 32)) // ← font Chewy
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 2)

                        Text("You've finished the game")
                            .font(.custom("Chewy", size: 28)) // ← font Chewy
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 2)
                    }
                    .padding(.top, 30)
                    .multilineTextAlignment(.center)

                    // MARK: - Home Button
                    Button {
                        // navigasi ke main menu — akan diisi saat routing siap
                    } label: {
                        Image("homeButton") // ← nama file aset tombol home
                            .resizable()
                            .scaledToFit()
                            .frame(width: homeButtonWidth, height: homeButtonHeight)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Preview

#Preview(traits: .landscapeRight) {
    EndView()
}
