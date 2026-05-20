//
//  AudioManager.swift
//  Behind-The-Reefs
//
//  Created by Ivone Liwang on 20/05/26.
//

import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    var bgmPlayer: AVAudioPlayer?

    func playBGM(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        bgmPlayer = try? AVAudioPlayer(contentsOf: url)
        bgmPlayer?.numberOfLoops = -1
        bgmPlayer?.volume = 1.0
        bgmPlayer?.play()
    }

    func stopBGM() {
        bgmPlayer?.stop()
        bgmPlayer = nil
    }
}
