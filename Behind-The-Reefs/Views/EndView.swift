//
//  EndView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

struct EndView: View {
    
    @Environment(NavigationRouter.self) private var router

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

                VStack(spacing: 24) {

                    VStack(spacing: 1) {
                        
                        Text("You've finished the game")
                            .font(.custom("Chewy", size: 28))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 2)
                    }
                    .padding(.top, 90)
                    .multilineTextAlignment(.center)

                    Button {
                        router.goToMainMenu()
                    } label: {
                        Image("homeButton")
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


#Preview(traits: .landscapeRight) {
    EndView()
        .environment(NavigationRouter())
}
