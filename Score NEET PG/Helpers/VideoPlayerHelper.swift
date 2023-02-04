//
//  VideoPlayerHelper.swift
//  Score MLE
//
//  Created by Manoj kumar on 02/08/22.
//

import Foundation
import AVKit

var videoPlayer: AVPlayer?

func playVideo(urlString: String) -> AVPlayer? {
    
    if let url = URL(string: urlString) {
        videoPlayer = AVPlayer(url: url)
        videoPlayer?.play()
    }
    return videoPlayer
}


func pauseVideo() {
    videoPlayer?.pause()
}
