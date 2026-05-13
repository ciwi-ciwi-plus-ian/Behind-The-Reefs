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
    @State private var rotatedKeys: [Bool] = Array(repeating: false, count: 5)

    // MARK: - Key Asset Names
    private let keyAssetNames = [
        "keyOne",   // index 0
        "keyTwo",   // index 1
        "keyThree", // index 2
        "keyFour",  // index 3
        "keyFive"   // index 4
    ]

    var body: some View {

        // ZStack agar background bisa ditaruh di belakang konten
        ZStack {

            // MARK: - Background
            // Ganti otomatis mengikuti state chestOpened
            // chestOpened false → chestBackgroundZoomOut (chest masih tertutup)
            // chestOpened true  → chestBackgroundZoomIn  (chest terbuka)
            Image(chestOpened ? "chestBackgroundZoomOut" : "chestBackgroundZoomIn")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: chestOpened) // transisi smooth saat berganti

            // MARK: - Konten (chest + keys)
            VStack {

                // Chest
                Image(chestOpened ? "chestOpened" : "chestClosed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400)
                    .offset(x: 0, y: 50)   

                // Keys
                HStack(spacing: 14) {

                    ForEach(0..<5, id: \.self) { index in

                        Image(keyAssetNames[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)

                            .rotationEffect(
                                .degrees(rotatedKeys[index] ? 180 : 30)
                            )
                            .offset(y: translateKeys ? -40 : 0)
                            .opacity(fadeKeys ? 0 : 1)

                            .animation(.easeInOut(duration: 1),  value: rotatedKeys[index])
                            .animation(.easeInOut(duration: 1),  value: translateKeys)
                            .animation(.easeOut(duration: 0.75), value: fadeKeys)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {

            // Rotate one by one
            for index in 0..<5 {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.5 + Double(index) * 0.15
                ) {
                    rotatedKeys[index] = true
                }
            }

            // Move semua kunci ke atas
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                translateKeys = true
            }

            // Fade semua kunci
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.50) {
                fadeKeys = true
            }

            // Buka chest — background ikut berganti ke chestBackgroundZoomIn
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
