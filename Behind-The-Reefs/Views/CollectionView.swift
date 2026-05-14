//
//  CollectionView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI
import SwiftData

struct CollectionView: View {

    var progress: GameProgress?

    @State private var viewModel = CollectionViewModel()

    // Ukuran kunci — sesuaikan di sini
    private let keySize:    CGFloat = 120
    private let keySpacing: CGFloat = 14
    private let chestWidth: CGFloat = 875

    // Opacity overlay gelap — sesuaikan di sini
    // 0.0 = tidak ada overlay, 1.0 = gelap total
    private let overlayOpacity: CGFloat = 0.5  // ← ubah nilai ini

    var body: some View {
        ZStack {

            // MARK: - Layer 1: Background
            Image("chestBackgroundZoomOut")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // MARK: - Layer 2: Chest
            // Chest diletakkan sebelum overlay agar ikut gelap
            VStack {
                ZStack {
                    VStack {
                        Image("chestClosed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: chestWidth)
                            .offset(y: -50)
                        Spacer()
                    }
                }
            }

            // MARK: - Layer 3: Overlay gelap
            // Hanya mengenai background dan chest di bawahnya
            // Keys yang ada di layer 4 ke atas tidak kena
            Color.black
                .opacity(overlayOpacity)
                .ignoresSafeArea()

            // MARK: - Layer 4: Keys
            // Di atas overlay — tidak kena efek gelap
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

            // MARK: - Layer 5: Exit Button (pojok kanan atas)
            // Di atas overlay — tidak kena efek gelap
            VStack {
                HStack {
                    Spacer()
                    Image("exitButton") // ← nama file aset exitButton
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(40)
                        .onTapGesture {
                            // kembali ke puzzle — akan diisi saat routing siap
                        }
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadKeyStatus(from: progress)
//            viewModel.keyUnlockStatus[1] = true
        }
    }

    // MARK: - Key Slot
    // Kalau unlock → gambar asli berwarna
    // Kalau belum  → siluet hitam

    @ViewBuilder
    private func keySlot(for index: Int) -> some View {
        if let assetName = viewModel.assetName(for: index) {

            // Kunci sudah didapat — gambar asli berwarna
            Image(assetName)
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(30))
                .shadow(color: .black.opacity(0.8), radius: 6, x: 4, y: 6)

        } else {

            // Kunci belum didapat — siluet hitam
            Image(viewModel.keyAssetNames[index])
                .resizable()
                .scaledToFit()
                .colorMultiply(.black)
                .opacity(0.8)
                .rotationEffect(.degrees(30))
                .shadow(color: .black.opacity(0.8), radius: 6, x: 4, y: 6)
        }
    }
}

// MARK: - Preview

#Preview(traits: .landscapeRight) {
    CollectionView(progress: nil)
}
