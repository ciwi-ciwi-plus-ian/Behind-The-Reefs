//
//  PuzzlePattern.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

//  Data statis 5 pola sorting — tidak perlu SwiftData
//  karena ini adalah data game yang tidak berubah,
//  bukan data yang disimpan per player.
//

import Foundation

// MARK: - SortCategory
// Kategori sorting untuk setiap pola

enum SortCategory: String {
    case height      = "Sort by Height"
    case legsOrFins  = "Sort by Legs / Fins"
    case direction   = "Sort by Direction"
    case pattern     = "Sort by Pattern"
    case dots        = "Sort by Dots"
}

// MARK: - PuzzlePattern
// Satu pola sorting beserta urutan jawaban yang benar
// correctOrder berisi spriteName dari kiri ke kanan

struct PuzzlePattern {
    let index: Int               // 0–4
    let category: SortCategory
    let correctOrder: [String]   // urutan spriteName yang benar
    let keyIndex: Int            // kunci ke berapa yang di-unlock setelah selesai

    // Nama kunci yang didapat setelah pola ini selesai
    var keySpriteName: String {
        "key_\(keyIndex + 1)"
    }
}

// MARK: - PuzzlePatternData
// Semua 5 pola — sesuaikan correctOrder dengan kunci jawaban
// yang sudah disepakati tim

enum PuzzlePatternData {

    static let all: [PuzzlePattern] = [

        // Pola 1 — Sort by Height (pendek → tinggi)
        PuzzlePattern(
            index: 0,
            category: .height,
            correctOrder: [
                "creature_squid",       // tinggi: 1 (paling pendek)
                "creature_seahorse",    // tinggi: 2
                "creature_fish",        // tinggi: 3
                "creature_nudibranch",  // tinggi: 4
                "creature_octopus",     // tinggi: 5
                "creature_shell"        // tinggi: 6 (paling tinggi)
            ],
            keyIndex: 0
        ),

        // Pola 2 — Sort by Legs / Fins (sedikit → banyak)
        PuzzlePattern(
            index: 1,
            category: .legsOrFins,
            correctOrder: [
                "creature_shell",       // 0 kaki/sirip
                "creature_seahorse",    // 2
                "creature_fish",        // 3
                "creature_nudibranch",  // 4
                "creature_squid",       // 6
                "creature_octopus"      // 8
            ],
            keyIndex: 1
        ),

        // Pola 3 — Sort by Direction
        PuzzlePattern(
            index: 2,
            category: .direction,
            correctOrder: [
                "creature_octopus",
                "creature_squid",
                "creature_seahorse",
                "creature_fish",
                "creature_shell",
                "creature_nudibranch"
            ],
            keyIndex: 2
        ),

        // Pola 4 — Sort by Pattern
        PuzzlePattern(
            index: 3,
            category: .pattern,
            correctOrder: [
                "creature_seahorse",
                "creature_octopus",
                "creature_nudibranch",
                "creature_squid",
                "creature_fish",
                "creature_shell"
            ],
            keyIndex: 3
        ),

        // Pola 5 — Sort by Dots (sedikit → banyak)
        PuzzlePattern(
            index: 4,
            category: .dots,
            correctOrder: [
                "creature_squid",
                "creature_octopus",
                "creature_nudibranch",
                "creature_seahorse",
                "creature_fish",
                "creature_shell"
            ],
            keyIndex: 4
        )
    ]

    // Ambil pola berdasarkan index
    static func pattern(at index: Int) -> PuzzlePattern? {
        return all[safe: index]
    }
}

// MARK: - Array safe subscript helper
// Agar tidak crash kalau index out of bounds

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
