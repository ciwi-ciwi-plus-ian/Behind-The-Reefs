//
//  MainMenuView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.

import SwiftUI

struct MainMenuView: View {

    var body: some View {

        ZStack {

            // Background
            Image("mainMenuBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // Title — fix di atas, tidak diubah
            VStack {
                Image("title")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 155)
                    .padding(.top, 50)
                Spacer()
            }

            // Buttons — geser ke bawah dengan padding top
            // Buttons — geser ke bawah dengan offset
            VStack {
                Spacer()
                VStack(spacing: -48) {
                    Button { } label: {
                        Image("continueButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                    }
                    Button { } label: {
                        Image("newGameButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                    }
                    Button { } label: {
                        Image("creditsButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                    }
                }
                Spacer()
            }
            .offset(y: 100)  // ← geser ke bawah, tidak mempengaruhi layout lain
        }
    }
}

#Preview(traits: .landscapeRight) {
    MainMenuView()
}
