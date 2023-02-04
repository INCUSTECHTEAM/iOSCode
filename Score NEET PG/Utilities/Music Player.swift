//
//  Music Player.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 13/12/22.
//

import Foundation
import AVKit

class MusicPlayer: ObservableObject {
    public static var instance = MusicPlayer()
    var player = AVPlayer()
    var finished = { }

    func initPlayer(url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        player = AVPlayer(playerItem: playerItem)
        playAudioBackground()
    }
    
    func playAudioBackground() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    func pause(){
        player.pause()
       
    }
    
    func play() {
        player.play()
       
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        // Your code here()
        finished()
        print("Audio Finished")
    }
    
}
