//
//  GameKey.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import Foundation
import SwiftData

// MARK: - GameKey
// Menyimpan status setiap kunci
// Selalu ada 5 record — satu per pola sorting
// Relasi: GameProgress has many GameKey

@Model
class GameKey {
    var patternIndex: Int     // 0 = pola 1, 1 = pola 2, dst
    var isUnlocked: Bool
    var unlockedAt: Date?     // nil kalau belum unlock

    // Nama sprite — dipakai KeySlotView untuk tampilkan gambar
    var spriteName: String    // "key_1", "key_2", dst
    var silhouetteName: String // "key_1_silhouette", dst

    init(patternIndex: Int) {
        self.patternIndex = patternIndex
        self.isUnlocked = false
        self.unlockedAt = nil
        self.spriteName = "key_\(patternIndex + 1)"
        self.silhouetteName = "key_\(patternIndex + 1)_silhouette"
    }

    // MARK: - Helper

    // Panggil saat player berhasil selesaikan satu pola
    func unlock() {
        guard !isUnlocked else { return }
        isUnlocked = true
        unlockedAt = Date()
    }

    // Nama asset yang ditampilkan — berwarna kalau unlock, siluet kalau belum
    var currentSpriteName: String {
        isUnlocked ? spriteName : silhouetteName
    }
}
