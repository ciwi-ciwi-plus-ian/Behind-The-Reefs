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

    // ← Ganti ini: langsung mulai di EndView untuk test
    @State private var router: NavigationRouter = {
        let r = NavigationRouter()
        r.path = [.tutorial]  // ← app langsung buka di EndView
        return r
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                MainMenuView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .letter:
                            LetterView()
                        case .loadingGame:
                            LoadingGameView()
                        case .tutorial:
                            TutorialView(isPresented: .constant(true))
                        case .puzzle:
                            PuzzleGameView()
                        case .keyResult(let index):
                            KeyResultView(
                                patternIndex: index,
                                isAllCompleted: false
                            )
                        case .collection:
                            CollectionView()
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
