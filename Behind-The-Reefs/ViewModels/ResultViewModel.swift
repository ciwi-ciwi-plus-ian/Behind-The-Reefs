//
//  ResultViewModel.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import SwiftUI
import SwiftData
 
// MARK: - KeyResultViewModel
// Mengelola logic saat satu pattern selesai:
// 1. Update SwiftData via GameProgress
// 2. Menyediakan data untuk KeyResultView
 
@Observable
class ResultViewModel {
 
    // Data yang ditampilkan di KeyResultView
    var sortDescription: String = ""
    var patternIndex:    Int    = 0
 
    // Deskripsi per pola — sesuaikan dengan PuzzlePattern kalian
    private let sortDescriptions = [
        "You've sorted the creatures by height",           // pola 0
        "You've sorted the creatures by legs/fins",        // pola 1
        "You've sorted the creatures by direction",        // pola 2
        "You've sorted the creatures by pattern",          // pola 3
        "You've sorted the creatures by number of dots"    // pola 4
    ]
 
    // MARK: - Setup
    // Panggil ini saat puzzle selesai — sebelum navigate ke KeyResultView
    func setup(patternIndex: Int) {
        self.patternIndex    = patternIndex
        self.sortDescription = sortDescriptions[safe: patternIndex]
            ?? "You've sorted the creatures!"
    }
 
    // MARK: - Save ke SwiftData
    // Panggil ini saat KeyResultView pertama muncul
    func saveProgress(progress: GameProgress?) {
        progress?.completePattern(patternIndex)
    }
}
 
// MARK: - Array safe subscript
private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
