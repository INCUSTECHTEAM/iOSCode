//
//  PPTScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 27/09/22.
//

import SwiftUI


struct AppUtility {
    
    static func orientationLandscape() {
        
        AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeRight
        
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight .rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    static func orientationPortrait() {
        
        AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
}
struct PPTScreen: View {
    //MARK: - PROPERTIES
    
    var webviewURL = ""
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    
    //MARK: - BODY
    var body: some View {
        VStack {
            CustomNavigationView()
                .padding(.horizontal)
            
            if let url = URL(string: webviewURL) {
                WebView(url: url)
            }
            
            Spacer()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { dats in
            DispatchQueue.main.async {
                
                print(dats)
                
                if UIDevice.current.orientation.isLandscape {
                    AppUtility.orientationLandscape()
                } else {
                    AppUtility.orientationPortrait()
                }
                
                
                
            }
        }
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        .gesture(
            DragGesture().onEnded { value in
                if value.location.y - value.startLocation.y > 150 {
                    /// Use presentationMode.wrappedValue.dismiss() for iOS 14 and below
                    dismiss()
                }
            }
        )
        .onAppear(perform: {
                    //AppUtility.orientationLandscape()
                })
        .onDisappear(perform: {
                    //AppUtility.orientationPortrait()
                })
    }
    
        
}

struct PPTScreen_Previews: PreviewProvider {
    static var previews: some View {
        PPTScreen()
    }
}
