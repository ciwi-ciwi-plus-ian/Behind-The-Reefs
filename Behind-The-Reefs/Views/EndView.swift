//
//  EndView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

struct EndView: View {

    private let frameWidth:       CGFloat = 500
    private let frameHeight:      CGFloat = 300
    private let homeButtonWidth:  CGFloat = 100
    private let homeButtonHeight: CGFloat = 60

    var body: some View {
        ZStack {

            // MARK: - Background
            Image("mainMenuBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.55))

            ZStack {

                Image("congratsFrame")
                    .resizable()
                    .scaledToFit()
                    .frame(width: frameWidth, height: frameHeight)

                VStack(spacing: 2) {

                    VStack(spacing: 1) {
                        
                        Text("Every reef has a story,")
                            .font(.custom("Sniglet", size: 20))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 2)
                        
                        Text("and now you've finished yours.")
                            .font(.custom("Sniglet", size: 20))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 2)
                        
                        Text("Thank you for playing with us!")
                            .font(.custom("Sniglet", size: 20))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 2)
                    }
                    .padding(.top, 88)
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
                    .padding(.top, 1)
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
