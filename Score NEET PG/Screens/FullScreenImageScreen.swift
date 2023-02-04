//
//  FullScreenImageScreen.swift
//  Score MLE
//
//  Created by ios on 01/08/22.
//

import SwiftUI
import Kingfisher

struct FullScreenImageScreen: View {
    // MARK: - PROPERTIES
    
    let item: Item
    @State private var imageSize: CGSize = .zero
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { proxy in
            VStack {
                KFImage(URL(string: item.image))
                    .resizable()
                    .onSuccess({ image in
                        DispatchQueue.main.async {
                            self.imageSize = CGSize(width: proxy.size.width, height: proxy.size.height)
                        }
                    })
                    .scaledToFit()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipShape(Rectangle())
                    .modifier(PinchZoomImageModifier(contentSize: imageSize))
                    .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
                    .overlay(
                        Image(systemName: "chevron.backward")
                            .tint(.textColor)
                            .frame(width: 10, height: 10, alignment: .center)
                            .padding(15)
                            .background(
                                Color.gray.opacity(0.3)
                            )
                            .cornerRadius(8)
                            .padding(15)
                            .onTapGesture {
                                withAnimation {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        
                        , alignment: .topLeading
                    )
            }
            .onAppear {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.all
                
            }
            .onDisappear {
                DispatchQueue.main.async {
                    AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    UINavigationController.attemptRotationToDeviceOrientation()
                }
            }
            
        }
    }
}

//struct FullScreenImageScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        FullScreenImageScreen(item: Item(image: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"))
//    }
//}
