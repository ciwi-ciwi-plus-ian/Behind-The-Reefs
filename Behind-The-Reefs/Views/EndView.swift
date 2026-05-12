//
//  EndView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

struct EndView: View {

    var body: some View {
        ZStack {

            // MARK: - Background
            Image("mainMenuBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 24) {

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
                .padding(.horizontal, 40)
                .padding(.vertical, 28)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.6))
                )

                // MARK: - Home Button
                Button {
                    // navigasi ke main menu — akan diisi saat routing siap
                } label: {
                    Text("Home")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.6))
                        )
                }
            }

            // MARK: - Home Icon (pojok kiri atas)
            VStack {
                HStack {
                    Image(systemName: "house.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(.orange)
                        .padding(16)
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Preview

#Preview(traits: .landscapeRight) {
    EndView()
}
