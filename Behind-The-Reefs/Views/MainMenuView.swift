//
//  MainMenuView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.

import SwiftUI
import SwiftData

struct MainMenuView: View {
    
    @Environment(NavigationRouter.self) private var router
    
    @State private var showNewGameAlert = false
    
    @Query private var progressList: [GameProgress]
        private var hasSavedProgress: Bool {
            guard let progress = progressList.first else { return false }
            return !progress.completedPatterns.isEmpty
        }

    var body: some View {

        ZStack {

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
                            .opacity(hasSavedProgress ? 1.0 : 0.4)
                    }
                    .disabled(!hasSavedProgress)
                    Button {
                        showNewGameAlert = true
                    } label: {
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
                .offset(y: 100)
                Spacer()
            }
            if showNewGameAlert {
                NewGameAlertView(
                    onDismiss: {
                        showNewGameAlert = false
                    },
                    onConfirm: {
                        showNewGameAlert = false
                        router.navigate(to: .letter)
                    }
                )
            }
        }
    }
}

#Preview(traits: .landscapeRight) {
    MainMenuView()
        .environment(NavigationRouter())
}
