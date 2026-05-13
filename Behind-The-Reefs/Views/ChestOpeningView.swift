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
    // Sesuaikan nama di sini kalau nama file aset berubah
    private let keyAssetNames = [
        "keyOne",   // index 0
        "keyTwo",   // index 1
        "keyThree", // index 2
        "keyFour",  // index 3
        "keyFive"   // index 4
    ] 

    var body: some View {

        VStack {

            // MARK: - Chest
            Image(chestOpened ? "chestOpened" : "chestClosed") // ← nama aset chest
                .resizable()
                .scaledToFit()
                .frame(width: 400)

            // MARK: - Keys
            // ForEach loop dari index 0–4
            // Setiap index ambil nama aset dari keyAssetNames[index]
            HStack(spacing: 14) {

                ForEach(0..<5, id: \.self) { index in

                    Image(keyAssetNames[index]) // ← ambil nama dari array
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)

                        // Rotate one by one
                        .rotationEffect(
                            .degrees(rotatedKeys[index] ? 180 : 30)
                        )

                        // Move together
                        .offset(y: translateKeys ? -40 : 0)

                        // Fade together
                        .opacity(fadeKeys ? 0 : 1)

                        .animation(.easeInOut(duration: 1),   value: rotatedKeys[index])
                        .animation(.easeInOut(duration: 1),   value: translateKeys)
                        .animation(.easeOut(duration: 0.75),  value: fadeKeys)
                }
            }
            .padding(.bottom, 30)
        }
        .onAppear {

            // Rotate one by one — setiap kunci rotate dengan jeda 0.15 detik
            for index in 0..<5 {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.5 + Double(index) * 0.15
                ) {
                    rotatedKeys[index] = true
                }
            }

            // Move semua kunci ke atas bersamaan
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                translateKeys = true
            }

            // Fade semua kunci bersamaan
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.50) {
                fadeKeys = true
            }

            // Buka chest
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
