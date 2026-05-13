//
//  ChestOpeningView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI

struct ChestOpeningView: View {

    @State private var chestOpened   = false
    @State private var translateKeys = false
    @State private var fadeKeys      = false

    // NEW
    @State private var showDarkOverlay = false

    @State private var rotatedKeys: [Bool] = Array(repeating: false, count: 5)

    // MARK: - Key Asset Names
    private let keyAssetNames = [
        "keyOne",
        "keyTwo",
        "keyThree",
        "keyFour",
        "keyFive"
    ]

    var body: some View {

        ZStack {

            // MARK: - Background
            Image(chestOpened ? "chestBackgroundZoomIn" : "chestBackgroundZoomOut")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: chestOpened)

            VStack {

                // MARK: - Chest Layer
                ZStack {
                    VStack {
                        // Chest
                        Image(chestOpened ? "chestOpened" : "chestClosed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: chestOpened ? 400 : 350)
                            .offset(y: chestOpened ? 10 : -60)
                        Spacer()
                    }

                    // Dark Overlay
                    if showDarkOverlay {
                        Color.black
                            .opacity(0.45)
                            .ignoresSafeArea()
                            .transition(.opacity)
                    }

                    // Keys
                    VStack {
                        Spacer()

                        HStack(spacing: 14) {

                            ForEach(0..<5, id: \.self) { index in

                                Image(keyAssetNames[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)

                                    .rotationEffect(
                                        .degrees(rotatedKeys[index] ? 180 : 30)
                                    )
                                    .offset(y: translateKeys ? 10 : 70)
                                    .opacity(fadeKeys ? 0 : 1)

                                    .animation(.easeInOut(duration: 1),
                                               value: rotatedKeys[index])

                                    .animation(.easeInOut(duration: 1),
                                               value: translateKeys)

                                    .animation(.easeOut(duration: 0.75),
                                               value: fadeKeys)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                    .frame(height: 300)
                }
            }
        }
        .onAppear {
            // SHOW overlay hitam selama 1 detik
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showDarkOverlay = true
                }
            }

            // Rotate one by one
            for index in 0..<5 {
                DispatchQueue.main.asyncAfter(
                    deadline: (.now()+1) + 0.5 + Double(index) * 0.15
                ) {
                    rotatedKeys[index] = true
                }
            }

            // HIDE overlay setelah 1 detik
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showDarkOverlay = false
                }

                // mulai translasi
                translateKeys = true
            }

            // Fade semua kunci
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                fadeKeys = true
            }

            // Open chest
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                chestOpened = true
            }
        }
    }
}

struct ChestOpeningView_Previews: PreviewProvider {
    static var previews: some View {
        ChestOpeningView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
