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

struct LoadingGameView: View {

    // Buat scene sekali saja — jangan buat ulang setiap render
    @State private var scene: LoadingScene = {
        let s = LoadingScene()
        s.scaleMode = .resizeFill
        return s
    }()

    var body: some View {
        SpriteView(scene: scene, options: [.allowsTransparency])
            .ignoresSafeArea()
            .navigationBarHidden(true)
            .background(.clear)
            .onDisappear {
                scene.stopAudio()
            }
    }
}
