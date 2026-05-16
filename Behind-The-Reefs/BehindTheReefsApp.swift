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

    @State private var router = NavigationRouter()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {

                // ← ROOT VIEW
                // Untuk test navigasi EndView → MainMenu, ganti ke EndView()
                // Setelah selesai test, ganti kembali ke MainMenuView()
                MainMenuView()

                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .letter:
                            LetterView()
                        case .loadingGame:
                            LoadingGameView()
//                        case .puzzle(let index):
//                            PuzzleGameView(patternIndex: index)
                        case .keyResult(let index):
                            KeyResultView(patternIndex: index)
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
