//
//  GameProgress.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//


import Foundation
import SwiftData
 
@Model
class GameProgress {
    var currentPatternIndex: Int
    var completedPatterns: [Int]
    var lastSolvedPatternIndex: Int?
    var hasStarted: Bool
 
    @Relationship(deleteRule: .cascade) var keys: [GameKey]
 
    init() {
        self.currentPatternIndex = 0
        self.completedPatterns = []
        self.keys = (0..<5).map { GameKey(patternIndex: $0) }
        self.hasStarted = false
    }
 
    // MARK: - Computed
 
    var isAllCompleted: Bool {
        completedPatterns.count == 5
    }
 
    func key(for patternIndex: Int) -> GameKey? {
        keys.first { $0.patternIndex == patternIndex }
    }
 
    // MARK: - Methods
    // Panggil ini saat player berhasil selesaikan satu pola
    func completePattern(_ index: Int) {
        guard !completedPatterns.contains(index) else { return }
        completedPatterns.append(index)
        key(for: index)?.unlock()
        lastSolvedPatternIndex = index
        if index + 1 < 5 {
            currentPatternIndex = index + 1
        }
    }
 
    // Ambil status unlock semua kunci — dipakai CollectionView
    // Return array [Bool] — index 0–4 sesuai urutan kunci
    var keyUnlockStatus: [Bool] {
        (0..<5).map { index in
            key(for: index)?.isUnlocked ?? false
        }
    }
}
