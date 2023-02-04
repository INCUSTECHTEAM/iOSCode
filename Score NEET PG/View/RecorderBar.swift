//
//  RecorderBar.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 12/12/22.
//

import SwiftUI

struct RecorderBar: View {
    @ObservedObject var audioRecorder = AudioRecorder()
    //@ObservedObject var audioPlayer: AudioPlayer
    
    @State var buttonSize: CGFloat = 1
    
    var uploadAudio = { (url: String) in }
    
    var repeatingAnimation: Animation {
        Animation.linear(duration: 0.5)
        .repeatForever()
    }
    
    var body: some View {
        if isStaff {
            VStack {
                
                if let audioRecorder = audioRecorder.audioRecorder, audioRecorder.isRecording {
                    TimelineView(.periodic(from: .now, by: 1)) { _ in
                        // recording duration
                        Text(DateComponentsFormatter.positional.string(from: audioRecorder.currentTime) ?? "0:00")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .transition(.scale)
                }
                
                recordButton
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
        } else {
            EmptyView()
        }
    }
    
    var recordButton: some View {
        Button {
            if audioRecorder.isRecording {
                stopRecording()
            } else {
                startRecording()
            }
        } label: {
            Image(systemName: audioRecorder.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipped()
                .foregroundColor(.orangeColor)
                .scaleEffect(buttonSize)
                .onChange(of: audioRecorder.isRecording) { isRecording in
                    if isRecording {
                        withAnimation(repeatingAnimation) { buttonSize = 1.1 }
                    } else {
                        withAnimation { buttonSize = 1 }
                    }
                }
        }
    }
    
    func startRecording() {
//        if audioPlayer.audioPlayer?.isPlaying ?? false {
//            // stop any playing recordings
//            audioPlayer.stopPlayback()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                // Start Recording
//                audioRecorder.startRecording()
//            }
//        } else {
//            // Start Recording
//            audioRecorder.startRecording()
//        }
        
        audioRecorder.startRecording()
        
    }
    
    func stopRecording() {
        // Stop Recording
        audioRecorder.stopRecording { url in
            uploadAudio(url)
        }
    }
    
}

struct RecorderBar_Previews: PreviewProvider {
    static var previews: some View {
        RecorderBar()
    }
}
