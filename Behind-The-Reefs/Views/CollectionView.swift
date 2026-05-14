//
//  CollectionView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI
import SwiftData
 
struct CollectionView: View {
 
    // Terima GameProgress dari PuzzleGameView
    var progress: GameProgress?
 
    @State private var viewModel = CollectionViewModel()
 
    // Ukuran kunci — sesuaikan di sini
    private let keySize:     CGFloat = 120
    private let keySpacing:  CGFloat = 20
    private let chestWidth:  CGFloat = 500
 
    var body: some View {
        ZStack {
 
            // MARK: - Background
            Image("chestBackgroundZoomOut") // ← nama file background sesuai ChestOpeningView
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
 
            VStack(spacing: 0) {
 
                Spacer()
 
                // MARK: - Chest Image (selalu tertutup di CollectionView)
                Image("chestClosed") // ← nama file aset chest tertutup
                    .resizable()
                    .scaledToFit()
                    .frame(width: chestWidth)
 
                // MARK: - Keys Row
                HStack(spacing: keySpacing) {
                    ForEach(0..<5, id: \.self) { index in
                        keySlot(for: index)
                    }
                }
                .padding(.bottom, 40)
            }
 
            // MARK: - Close Button (pojok kanan atas)
            VStack {
                HStack {
                    Spacer()
                    Image("closeButton") // ← nama file aset tombol close/X
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .padding(20)
                        .onTapGesture {
                            // Kembali ke puzzle — handle di PuzzleGameView
                            // akan diisi saat routing siap
                        }
                }
                Spacer()
            }
 
            // MARK: - Counter pojok kiri atas
            VStack {
                HStack {
                    Text("\(viewModel.collectedCount)/5")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(20)
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadKeyStatus(from: progress)
        }
    }
 
    // MARK: - Key Slot
    // Tampilkan gambar asli kalau unlock, siluet hitam kalau belum
 
    @ViewBuilder
    private func keySlot(for index: Int) -> some View {
        if let assetName = viewModel.assetName(for: index) {
 
            // Kunci sudah didapat — tampilkan gambar asli
            Image(assetName)
                .resizable()
                .scaledToFit()
                .frame(width: keySize, height: keySize)
 
        } else {
 
            // Kunci belum didapat — tampilkan siluet hitam dari kode
            // Pakai gambar asli tapi di-overlay hitam penuh
            Image(viewModel.keyAssetNames[index])
                .resizable()
                .scaledToFit()
                .frame(width: keySize, height: keySize)
                .colorMultiply(.black) // ← jadikan siluet hitam tanpa perlu aset terpisah
                .opacity(0.8)
                .rotationEffect(.degrees(30))
        }
    }
}
 
// MARK: - Preview
 
#Preview(traits: .landscapeRight) {
    CollectionView(progress: nil)
}
