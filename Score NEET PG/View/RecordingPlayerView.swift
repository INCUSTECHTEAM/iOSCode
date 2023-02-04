//
//  RecordingPlayerView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 09/12/22.
//

import SwiftUI
import AVKit
import AudioPlayer


struct RecordingPlayerView: View {
    //MARK: - PROPERTIES
    
    var audioData = AudioData()
    @ObservedObject var player: Player
    @State var isLoading: Bool = false
    
    
   // var audioData: AudioData
    let phone = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber)
    
    
    /// Return a formatter for durations.
    var durationFormatter: DateComponentsFormatter {

        let durationFormatter = DateComponentsFormatter()
        durationFormatter.allowedUnits = [.minute, .second]
        durationFormatter.unitsStyle = .positional
        durationFormatter.zeroFormattingBehavior = .pad

        return durationFormatter
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
                    switch self.player.timeControlStatus {
                    case .paused:
                        self.player.play()
                    case .waitingToPlayAtSpecifiedRate:
                        self.player.pause()
                    case .playing:
                        self.player.pause()
                    @unknown default:
                        fatalError()
                    }
                } label: {
                    Image(systemName: self.player.timeControlStatus == .paused ? "play.fill" : "pause.fill")
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
            
            Image(systemName: "speaker.wave.2")
                .foregroundColor(.white)
            
          
            if self.player.itemDuration > 0 {
                Slider(value: self.$player.displayTime, in: (0...self.player.itemDuration), onEditingChanged: {
                    (scrubStarted) in
                    if scrubStarted {
                        self.player.scrubState = .scrubStarted
                    } else {
                        self.player.scrubState = .scrubEnded(self.player.displayTime)
                    }
                })
            } else {
                Text("Slider will appear here when the player is ready")
                    .font(.footnote)
            }
            
//            Text("formattedProgress")
//                .font(.custom(K.Font.sfUITextRegular, size: 11))
//                .foregroundColor(.textColor)
            
            
         //   if (audioData.user == phone) {
                Button {
                    //Action
                    
                } label: {
                    Image(systemName: "xmark.bin.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                        .padding(.all)
                }
          //  }
            
            
            
            
            Spacer()
            
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.gradient1, .gradient2]), startPoint: .top, endPoint: .bottom)
                .cornerRadius(8, corners: .allCorners)
        )
    }
}

//struct RecordingPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingPlayerViewplayer: <#Player#>)
//            .previewLayout(.sizeThatFits)
//    }
//}
