//
//  CollectionViewModel.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI
import SwiftData
 
// MARK: - CollectionViewModel
// Menyediakan data status kunci untuk CollectionView
// Membaca langsung dari SwiftData via GameProgress
 
@Observable
class CollectionViewModel {
 
    // Status unlock 5 kunci — index 0–4
    // true  = kunci sudah didapat (tampil gambar asli)
    // false = kunci belum didapat (tampil siluet hitam)
    var keyUnlockStatus: [Bool] = Array(repeating: false, count: 5)
 
    // Nama aset kunci asli
    let keyAssetNames = [
        "keyOne",
        "keyTwo",
        "keyThree",
        "keyFour",
        "keyFive"
    ]
 
    // MARK: - Load dari SwiftData
    // Panggil ini saat CollectionView muncul
    func loadKeyStatus(from progress: GameProgress?) {
        guard let progress = progress else { return }
        keyUnlockStatus = progress.keyUnlockStatus
    }
 
    // Nama aset yang ditampilkan per slot
    // Kalau unlock → gambar asli, kalau belum → nil (pakai overlay hitam dari kode)
    func assetName(for index: Int) -> String? {
        guard index >= 0 && index < keyAssetNames.count else { return nil }
        return keyUnlockStatus[index] ? keyAssetNames[index] : nil
    }
 
    // Jumlah kunci yang sudah terkumpul
    var collectedCount: Int {
        keyUnlockStatus.filter { $0 }.count
    }
}
