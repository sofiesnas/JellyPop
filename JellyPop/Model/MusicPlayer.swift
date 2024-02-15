//
//  MusicPlayer.swift
//  JellyPop
//
//  Created by Syafa Sofiena on 28/4/2023.
//

import AVFoundation

// Class for playing background music
class MusicPlayer {
    
    static let shared = MusicPlayer()
    private var musicPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "JellyPopSong", withExtension: "mp3") else {
            print("Error: Failed to locate audio file")
            return
        }
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.prepareToPlay()
            musicPlayer?.play()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundMusic() {
        musicPlayer?.stop()
    }
    
    func restartBackgroundMusic() {
        musicPlayer?.play()
    }
}
