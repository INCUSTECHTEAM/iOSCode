//
//  RecordingPlayerViewWithoutSlider.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 12/12/22.
//

import SwiftUI
import AudioPlayer
import AVFoundation
import AVKit

class SoundManager : ObservableObject {
    var audioPlayer: AVPlayer?
    
    func playSound(sound: String){
        if let url = URL(string: sound) {
            self.audioPlayer = AVPlayer(url: url)
        }
    }
}

struct RecordingPlayerViewWithoutSlider: View {
    
    @State var isLoading: Bool = false
    @State var isPlaying: Bool = false
    @State var isFirstPlay: Bool = false
    @StateObject private var soundManager = SoundManager()
    let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber)
    
    var audioData: AudioData
    
    var deleteAudio = {}
    
    
        var timer: Timer?
        var index: Int = Int()
       @State var avPlayer: AVPlayer!
        @State var isPaused: Bool = true
    
    
    //MARK: - FUNCTIONS
    
    func play(url:URL) {
        isPaused = false
        self.avPlayer = AVPlayer(playerItem: AVPlayerItem(url: url))
        self.avPlayer.automaticallyWaitsToMinimizeStalling = false
        avPlayer!.volume = 1.0
        avPlayer.play()
    }
    
    
    func togglePlayPause() {
        if avPlayer.timeControlStatus == .playing  {
            avPlayer.pause()
            isPaused = true
        } else {
            avPlayer.play()
            isPaused = false
        }
    }
    
    
    
    
    //MARK: - BODY
    
    var body: some View {
        HStack {
          
            if isLoading {
                ProgressView()
                    .tint(.white)
                    .padding(.all)
                
            } else {
                Button {
                    
                    if !isFirstPlay {
                        guard let url = URL(string: audioData.audio ?? "") else {
                             return
                        }
                        isFirstPlay = true
                        play(url: url)
                        
                    } else {
                        togglePlayPause()
                    }
                    
//                    if isPlaying {
//                        isPlaying = false
//                        MusicPlayer.instance.pause()
//                    } else {
//                        isPlaying = true
//                        MusicPlayer.instance.play()
//
//                    }
                    
                   // togglePlayPause()
                    
                   
                        
                    
                        //MusicPlayer.instance.pause()
                    
                    
//                    soundManager.playSound(sound: audioData.audio ?? "")
//                    isPlaying.toggle()
//                    soundManager.audioPlayer?.play()
//
//                    if isPlaying {
//                        soundManager.audioPlayer?.play()
//                    } else {
//                        soundManager.audioPlayer?.pause()
//                    }
                } label: {
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .padding(.all, 10)
                    
                }
                .background {
                    Circle()
                        .foregroundColor(.white)
                }
                .padding(.all)
            }
            
            Spacer()
            
            
            
            if (audioData.user == phoneNumber) || (isStaff == true) {
                Button {
                    //Action
                    deleteAudio()
                    
                } label: {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                        .padding(.all)
                }
            }
            
        }
        .onAppear(perform: {
            //MusicPlayer.instance.initPlayer(url: audioData.audio ?? "")
//            guard let url = URL(string: audioData.audio ?? "") else {
//                 return
//            }
           // play(url: url)
        })
        .background(
            LinearGradient(gradient: Gradient(colors: [.gradient1, .gradient2]), startPoint: .top, endPoint: .bottom)
                .cornerRadius(8, corners: .allCorners)
        )
        .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
            print("Stopped")
            isFirstPlay = false
            isPaused = true
        }
        
        
    }
}

struct RecordingPlayerViewWithoutSlider_Previews: PreviewProvider {
    static var previews: some View {
        RecordingPlayerViewWithoutSlider(audioData: AudioData())
    }
}
