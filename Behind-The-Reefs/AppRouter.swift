//
//  AppRouter.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

// MARK: - AppRoute
enum AppRoute: Hashable {
    case letter
    case tutorial                  
    case puzzle
//    case puzzle(patternIndex: Int)
    case keyResult(patternIndex: Int)
    case chestOpening
    case end
//    case credits
}

// MARK: - NavigationRouter
@Observable
class NavigationRouter {

    var path: [AppRoute] = []

    func navigate(to route: AppRoute) {
        path.append(route)
    }

    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func goToMainMenu() {
        path.removeAll()
    }

//    func goToNextPuzzle(from currentIndex: Int) {
//        let nextIndex = currentIndex + 1
//        if nextIndex < 5 {
//            navigate(to: .puzzle(patternIndex: nextIndex))
//        } else {
//            navigate(to: .chestOpening)
//        }
//    }
}
