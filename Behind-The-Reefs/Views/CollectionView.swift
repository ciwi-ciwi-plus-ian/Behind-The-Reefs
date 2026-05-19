//
//  CollectionView.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI
import SwiftData

struct CollectionView: View {
    
    @Environment(NavigationRouter.self) private var router
    @Environment(\.dismiss) private var dismiss
    
    @Query private var progressList: [GameProgress]
        private var progress: GameProgress? { progressList.first }

    @State private var viewModel = CollectionViewModel()

    private let keySize:    CGFloat = 120
    private let keySpacing: CGFloat = 14
    private let chestWidth: CGFloat = 550

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
                            .offset(y: 50)
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
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadKeyStatus(from: progress)
        }
        .onChange(of: progress) { _, newProgress in
            viewModel.loadKeyStatus(from: newProgress)
        }
    }

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

#Preview(traits: .landscapeRight) {
    CollectionView()
        .environment(NavigationRouter())
}
