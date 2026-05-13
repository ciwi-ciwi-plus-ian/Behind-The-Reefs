//
//  AudioSettings.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 12/05/26.
//

import Foundation
import SwiftData

// MARK: - AudioSettings
// Menyimpan preferensi audio player
// Relasi: PlayerData has one AudioSettings

@Model
class AudioSettings {
    var bgmVolume: Float
    var sfxVolume: Float
    var isHapticsEnabled: Bool

    init(
        bgmVolume: Float = 0.7,
        sfxVolume: Float = 1.0,
        isHapticsEnabled: Bool = true
    ) {
        self.bgmVolume = bgmVolume
        self.sfxVolume = sfxVolume
        self.isHapticsEnabled = isHapticsEnabled
    }
}
