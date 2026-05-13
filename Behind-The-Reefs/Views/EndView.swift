//
//  EndView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

struct EndView: View {

    // MARK: - Button Size
    // Sesuaikan nilai ini untuk atur besar kecil homeButton
    private let homeButtonWidth:  CGFloat = 100
    private let homeButtonHeight: CGFloat = 60

    var body: some View {
        ZStack {

            // MARK: - Background
            Image("mainMenuBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.4))

            VStack(spacing: 30) {

                // MARK: - Congratulations Card
                VStack(spacing: 8) {
                    Text("Congratulations!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)

                    Text("You Finished the game >0<")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                }
                .padding(.horizontal, 60)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.6))
                )

                // MARK: - Home Button
                Button {
                    // navigasi ke main menu — akan diisi saat routing siap
                } label: {
                    Image("homeButton") // ← aset tombol home
                        .resizable()
                        .scaledToFit()
                        .frame(width: homeButtonWidth, height: homeButtonHeight)
                }
            }
            .padding(.top, 50)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Preview

#Preview(traits: .landscapeRight) {
    EndView()
}
