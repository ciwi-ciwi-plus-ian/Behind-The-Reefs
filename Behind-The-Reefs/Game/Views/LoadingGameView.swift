//
//  LoadingGameView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//


//
//  LoadingGameView.swift
//  Behind-The-Reefs
//

import SwiftUI
import SpriteKit

// MARK: - LoadingGameView
// SwiftUI wrapper untuk LoadingScene
// Navigasi akan ditambahkan belakangan

struct LoadingGameView: View {

    // Buat scene sekali saja — jangan buat ulang setiap render
    @State private var scene: LoadingScene = {
        let s = LoadingScene()
        s.scaleMode = .resizeFill  // fill seluruh layar
        return s
    }()

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()          // full screen
            .navigationBarHidden(true)  // sembunyikan nav bar
    }
}
