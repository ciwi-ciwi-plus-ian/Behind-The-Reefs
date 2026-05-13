//
//  PlayerData.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//


import Foundation
import SwiftData

// MARK: - PlayerData
// Root model — hanya ada 1 instance per device
// Menjadi pintu masuk ke semua data player lainnya

@Model
class PlayerData {
    var createdAt: Date
    var lastPlayedAt: Date
    var isGameCompleted: Bool

    // Relasi ke GameProgress dan AudioSettings
    // deleteRule .cascade → kalau PlayerData dihapus, semua relasi ikut terhapus
    @Relationship(deleteRule: .cascade) var progress: GameProgress?
    @Relationship(deleteRule: .cascade) var audioSettings: AudioSettings?

    init() {
        self.createdAt = Date()
        self.lastPlayedAt = Date()
        self.isGameCompleted = false
        self.progress = GameProgress()
        self.audioSettings = AudioSettings()
    }

    // MARK: - Computed Properties

    // Cek apakah ada progress yang bisa di-continue
    // Dipakai MainMenuViewModel untuk enable/disable tombol Continue
    var hasSavedProgress: Bool {
        guard let progress = progress else { return false }
        return !progress.completedPatterns.isEmpty
    }

    // MARK: - Methods

    // Update lastPlayedAt setiap kali player buka game
    func updateLastPlayed() {
        lastPlayedAt = Date()
    }

    // Tandai game sebagai selesai
    func completeGame() {
        isGameCompleted = true
    }
}
