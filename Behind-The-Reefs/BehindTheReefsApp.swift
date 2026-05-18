//
//  BehindTheReefsApp.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI
import SwiftData

@main
struct BehindTheReefsApp: App {

    @State private var router =  NavigationRouter()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                MainMenuView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .letter:
                            LetterView()
                        case .tutorial:
                            TutorialView(isPresented: .constant(true))
                        case .puzzle:
                            PuzzleGameView()
                        case .keyResult(let index):
                            KeyResultView(
                                patternIndex: index,
                                isAllCompleted: false
                            )
                        case .chestOpening:
                            ChestOpeningView()
                        case .end:
                            EndView()
//                        case .credits:
//                            CreditsView()
                        }
                    }
            }
            .environment(router)
        }
        .modelContainer(for: [
            PlayerData.self,
            GameProgress.self,
            GameKey.self,
            AudioSettings.self
        ])
    }
}
