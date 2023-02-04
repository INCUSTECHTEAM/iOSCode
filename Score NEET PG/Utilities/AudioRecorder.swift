//
//  AudioRecorder.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 12/12/22.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine

class AudioRecorder: NSObject,ObservableObject {
    
    var audioRecorder: AVAudioRecorder?
    
    @Published private var recordingName = "Recording1"
    @Published private var recordingDate = Date()
    @Published var recordingURL: URL?
    
    @Published var isRecording = false
    
    
    // MARK: - Start Recording
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.record, mode: .default)
            try recordingSession.setActive(true)
            print("Start Recording - Recording session setted")
        } catch {
            debugPrint(error)
            print("Start Recording - Failed to set up recording session \(error)")
        }
        
        let currentDateTime = Date.now
        
        recordingDate = currentDateTime
        recordingName = "\(currentDateTime.toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss"))"
        
        // save the recording to the temporary directory
        let tempDirectory = FileManager.default.temporaryDirectory
        let recordingFileURL = tempDirectory.appendingPathComponent(recordingName).appendingPathExtension("m4a")
        recordingURL = recordingFileURL
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingFileURL, settings: settings)
            audioRecorder?.record()
            
            withAnimation {
                isRecording = true
            }
            print("Start Recording - Recording Started")
        } catch {
            debugPrint(error)
            print("Start Recording - Could not start recording \(error)")
        }
    }
    
    // MARK: - Stop Recording
    
    func stopRecording(completion: @escaping (_ url: String) -> Void) {
        audioRecorder?.stop()
        withAnimation {
            isRecording = false
        }
        
        if let recordingURL {
            
            AWSS3Manager.shared.uploadAudio(audioUrl: recordingURL) { progress in
                print("Loading")
            } completion: { response, error in
                if let _ =  error {
                    return
                }
                
                guard let response = response as? String else {
                    return
                }
                
                completion(response)
            }
            
        } else {
            print("Stop Recording -  Could not save to CoreData - Cannot find the recording URL")
        }
        
    }
    
    
    //MARK: - CREATING AWS LINK ------------------------------
    
    
    
    // MARK: - CoreData --------------------------------------
    
//    func saveRecordingOnCoreData(recordingData: Data) {
//        let newRecording = Recording(context: moc)
//        newRecording.id = UUID()
//        newRecording.name = recordingName
//        newRecording.createdAt = recordingDate
//        newRecording.recordingData = recordingData
//        
//        do {
//            try moc.save()
//            print("Stop Recording - Successfully saved to CoreData")
//            // delete the recording stored in the temporary directory
//            deleteRecordingFile()
//        } catch {
//            let nsError = error as NSError
//            fatalError("Stop Recording - Failed to save to CoreData - Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
    
    func deleteRecordingFile() {
        if let recordingURL {
            do {
               try FileManager.default.removeItem(at: recordingURL)
                print("Stop Recording - Successfully deleted the recording file")
            } catch {
                print("Stop Recording - Could not delete the recording file - Cannot find the recording URL")
            }
        }
    }
    
}
