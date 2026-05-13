//
//  GameProgress.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//


import Foundation
import SwiftData

// MARK: - GameProgress
// Menyimpan progress puzzle player
// Relasi: PlayerData has one GameProgress
//         GameProgress has many GameKey (5 keys)

@Model
class GameProgress {
    var currentPatternIndex: Int   // pola yang sedang dikerjakan (0–4)
    var completedPatterns: [Int]   // index pola yang sudah selesai

    // Relasi ke 5 GameKey
    // deleteRule .cascade → kalau GameProgress dihapus, semua key ikut terhapus
    @Relationship(deleteRule: .cascade) var keys: [GameKey]

    init() {
        self.currentPatternIndex = 0
        self.completedPatterns = []

        // Buat 5 GameKey otomatis saat GameProgress dibuat
        self.keys = (0..<5).map { GameKey(patternIndex: $0) }
    }

    // MARK: - Computed Properties

    // Cek apakah semua 5 pola sudah selesai
    var isAllCompleted: Bool {
        completedPatterns.count == 5
    }

    // Ambil kunci berdasarkan patternIndex
    func key(for patternIndex: Int) -> GameKey? {
        keys.first { $0.patternIndex == patternIndex }
    }

    // MARK: - Methods

    // Panggil saat player berhasil selesaikan satu pola
    func completePattern(_ index: Int) {
        // Jangan proses kalau sudah selesai sebelumnya
        guard !completedPatterns.contains(index) else { return }

        // Tandai pola sebagai selesai
        completedPatterns.append(index)

        // Unlock kunci yang sesuai
        key(for: index)?.unlock()

        // Update currentPatternIndex ke pola berikutnya
        if index + 1 < 5 {
            currentPatternIndex = index + 1
        }
    }
}
