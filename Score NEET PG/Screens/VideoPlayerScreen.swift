//
//  VideoPlayerScreen.swift
//  Score MLE
//
//  Created by Manoj kumar on 02/08/22.
//

import SwiftUI
import AVKit

struct VideoPlayerScreen: View {
    // MARK: - PROPERTIES
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    
    @State private var isLandscape = false
    
    
    
    let item: Item
    @State var videoURL: String = ""
    @State var isLoading = false
    @State private var showFullScreen = false

    
    // MARK: - FUNCTION
    
    private func getVideoURL() {
        isLoading = true
        VimeoManager.shared.getVideoURL(vimeoId: item.image) { result in
            isLoading = false
            switch result {
            case .success(let url):
                videoURL = url
            case .failure(_):
                break
            }
        }
    }
    
    private func screenOrienration() {
        if isLandscape {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        } else {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
            
        }
    }
    
    
    func changeOrientation(to orientation: UIInterfaceOrientation) {
        // tell the app to change the orientation
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        print("Changing to", orientation.isPortrait ? "Portrait" : "Landscape")
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VideoPlayer(player: playVideo(urlString: videoURL))
            } //: VSTACK
            .onAppear {
                getVideoURL()
                AppDelegate.orientationLock = UIInterfaceOrientationMask.all
                
            }
            .onDisappear {
                pauseVideo()
                DispatchQueue.main.async {
                    AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    UINavigationController.attemptRotationToDeviceOrientation()
                }
            }
            
            if self.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
        } //: ZSTACK
        .gesture(
            DragGesture().onEnded { value in
                if value.location.y - value.startLocation.y > 150 {
                    /// Use presentationMode.wrappedValue.dismiss() for iOS 14 and below
                    dismiss()
                }
            }
        )
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct VideoPlayerScreen_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerScreen(item: Item(image: "8484747"))
            .previewInterfaceOrientation(.portrait)
    }
}
