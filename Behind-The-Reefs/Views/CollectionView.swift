//
//  CollectionView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI
import SwiftData
import AVFoundation

struct CollectionView: View {

    @Environment(NavigationRouter.self) private var router
    @Environment(\.dismiss) private var dismiss

    @Query private var progressList: [GameProgress]
    private var progress: GameProgress? { progressList.first }

    @State private var viewModel = CollectionViewModel()
    @State private var selectedKeyIndex: Int? = nil
    @State private var keyOffsets: [CGFloat] = Array(repeating: -50, count: 5)
    @State private var buttonSoundPlayer: AVAudioPlayer?

    private let keySize:        CGFloat = 120
    private let keySpacing:     CGFloat = 14
    private let chestWidth:     CGFloat = 550
    private let overlayOpacity: CGFloat = 0.5

    var body: some View {
        ZStack {

            Image("chestBackgroundZoomOut")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                ZStack {
                    VStack {
                        Image("chestClosed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: chestWidth)
                            .offset(x: 10, y: 50)
                        Spacer()
                    }
                }
            }

            Color.black
                .opacity(overlayOpacity)
                .ignoresSafeArea()

            VStack {
                ZStack {
                    VStack {
                        Spacer()
                        HStack(spacing: keySpacing) {
                            ForEach(0..<5, id: \.self) { index in
                                keySlot(for: index)
                                    .frame(width: keySize, height: keySize)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                    .frame(height: 400)
                }
            }

            VStack {
                HStack {
                    Spacer()
                    Button {
                        playButtonSound()
                        dismiss()
                    } label: {
                        Image("exitButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .padding(40)
                            .padding(.trailing, 10)
                    }
                }
                Spacer()
            }

            if let index = selectedKeyIndex {
                KeyResultView(
                    patternIndex: index,
                    hideButtons: true,
                    onDismiss: {
                        selectedKeyIndex = nil
                    }
                )
                .zIndex(10)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadKeyStatus(from: progress)
        }
        .onChange(of: progress) { _, newProgress in
            viewModel.loadKeyStatus(from: newProgress)
        }
        .onChange(of: viewModel.keyUnlockStatus) { _, _ in
            triggerAnimation()
        }
        .task {
            viewModel.loadKeyStatus(from: progress)
            try? await Task.sleep(nanoseconds: 100_000_000)
            triggerAnimation()
        }
    }

    private func triggerAnimation() {
        for i in 0..<5 {
            keyOffsets[i] = 0

            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
                .delay(Double(i) * 0.2)  // delay per kunci agar tidak serentak
            ) {
                keyOffsets[i] = -10  // ← atur seberapa jauh naik turunnya
            }
        }
    }

    // MARK: - Key Slot

    @ViewBuilder
    private func keySlot(for index: Int) -> some View {
        if let assetName = viewModel.assetName(for: index) {

            // Kunci sudah didapat — animasi turun + bisa diklik
            Image(assetName)
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(30))
                .shadow(color: .black.opacity(0.8), radius: 6, x: 4, y: 6)
                .offset(y: keyOffsets[index])  // ← animasi turun
                .onTapGesture {
                    selectedKeyIndex = index
                }

        } else {

            // Kunci belum didapat — siluet, tidak animasi, tidak bisa diklik
            Image(viewModel.keyAssetNames[index])
                .resizable()
                .scaledToFit()
                .colorMultiply(.black)
                .opacity(0.8)
                .rotationEffect(.degrees(30))
                .shadow(color: .black.opacity(0.8), radius: 6, x: 4, y: 6)
        }
    }
    
    private func playButtonSound() {
        guard let url = Bundle.main.url(
            forResource: "exitSound",
            withExtension: "mp3"
        ) else { return }
        buttonSoundPlayer = try? AVAudioPlayer(contentsOf: url)
        buttonSoundPlayer?.play()
    }
}

#Preview(traits: .landscapeRight) {
    CollectionView()
        .environment(NavigationRouter())
}
