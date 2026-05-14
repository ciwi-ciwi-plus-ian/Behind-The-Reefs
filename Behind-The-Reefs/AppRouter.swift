//
//  AppRouter.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

// MARK: - AppRoute
// Semua destinasi navigasi dalam game

enum AppRoute: Hashable {
    case letter                      // Frame 1 — letter screen
    case loadingGame                 // Frame 2 — bubble screen
    case puzzle(patternIndex: Int)   // Frame 3 — puzzle scene
    case keyResult(patternIndex: Int)// Frame 4 — key result
    case collection                  // Supporting — collectible keys
    case chestOpening                // Frame 5 — opening chest animation
    case end                         // end screen
    case credits                     // credits
}

// MARK: - NavigationRouter
// @Observable agar SwiftUI otomatis re-render saat path berubah

@Observable
class NavigationRouter {

    var path: [AppRoute] = []

    // MARK: - Navigate

    // Push screen baru
    func navigate(to route: AppRoute) {
        path.append(route)
    }

    // Pop ke screen sebelumnya
    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    // Kembali ke Main Menu — hapus seluruh stack
    func goToMainMenu() {
        path.removeAll()
    }

    // Lanjut ke puzzle berikutnya
    // Otomatis increment patternIndex
    func goToNextPuzzle(from currentIndex: Int) {
        let nextIndex = currentIndex + 1
        if nextIndex < 5 {
            navigate(to: .puzzle(patternIndex: nextIndex))
        } else {
            navigate(to: .chestOpening)
        }
    }
}
