//
//  ImageView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 14/08/22.
//

import SwiftUI
import Kingfisher

struct ImageView: View {
    
    @Binding var selectedImageID: String
    @Binding var images: [String]
    @Binding var showImageViewer: Bool
    @Environment(\.presentationMode) var presentationMode
    
    // since onChange has a problem in drage gesture
    @GestureState var draggingOffset: CGSize = .zero
    @State var imageViewerOffset: CGSize = .zero
    @State var bgOpacity: Double = 1
    @State var imageScale: CGFloat = 1
    
    // MARK: - FUNCTIONS
    
    func onChange(value: CGSize) {
        imageViewerOffset = value
        
        //calculating opacity
        let halgHeight = UIScreen.main.bounds.height / 2
        
        let progress = imageViewerOffset.height / halgHeight
        
        withAnimation {
            bgOpacity = Double(1 - (progress < 0 ? -progress : progress))
        }
    }
    
    func onEnded(value: DragGesture.Value) {
        withAnimation(.easeInOut) {
            var translation = value.translation.height
            
            if translation < 0 {
                translation = -translation
            }
            
            if translation < 250 {
                imageViewerOffset = .zero
                bgOpacity = 1
            } else {
                
                imageViewerOffset = .zero
                bgOpacity = 1
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView(.init()) {
                TabView(selection: $selectedImageID) {
                    ForEach(images, id: \.self) { image in
                        KFImage(URL(string: image.trimmingCharacters(in: .whitespaces)))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .tag(image)
                            .scaleEffect(selectedImageID == image ? (imageScale > 1 ? imageScale : 1) : 1)
                            .offset(imageViewerOffset)
                            .gesture(
                                // Magnifying Gesture
                                MagnificationGesture().onChanged({ value in
                                    imageScale = value
                                }).onEnded({ _ in
                                    withAnimation(.spring()) {
                                        imageScale = 1
                                    }
                                })
                                //Double to Zoom
                                    .simultaneously(with: TapGesture(count: 2).onEnded({
                                        withAnimation {
                                            imageScale = imageScale > 1 ? 1 : 4
                                        }
                                    }))
                            )
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .overlay(
                    
                    Button(action: {
                        withAnimation(.default) {
                            //showImageViewer.toggle()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .tint(.textColor)
                            .frame(width: 10, height: 10, alignment: .center)
                            .padding(15)
                            .background(
                                Color.gray.opacity(0.3)
                            )
                            .cornerRadius(8)
                    })
                    .padding(10)
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    
                    ,alignment: .topLeading
            )
            }
            .ignoresSafeArea()
            
            
        }
        .gesture(DragGesture().updating($draggingOffset, body: { value, outValue, _ in
            
            outValue = value.translation
            onChange(value: draggingOffset)
        }).onEnded(onEnded(value:)))
        .transition(.move(edge: .bottom))
    }
}

//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView()
//    }
//}
