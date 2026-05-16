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

            VStack {
                Image("title")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 155)
                    .padding(.top, 50)
                Spacer()
            }

            VStack {
                Spacer()
                VStack(spacing: 10) {
                    Button { } label: {
                        Image("continueButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    Button { } label: {
                        Image("newGameButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    Button { } label: {
                        Image("creditsButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                }
                Spacer()
            }
            .offset(y: 100)
        }
    }
}

#Preview(traits: .landscapeRight) {
    MainMenuView()
}
