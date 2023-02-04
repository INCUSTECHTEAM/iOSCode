//
//  GridImageView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 14/08/22.
//

import SwiftUI
import Kingfisher

struct GridImageView: View {
    //MARK: - PROPERTIES
    
    var images: [String]
    var index: Int
    @Binding var showingImageViewer: Bool
    @Binding var selectedImageID: String
    @State private var fullScreenPresented: Bool = false
    
    //MARK: - FUNCTIONS
    
    func getWidth(index: Int) -> CGFloat {
        
        let width = getRect().width - 100
        
        if images.count % 2 == 0 {
            return width / 3
        } else {
            if index == images.count - 1 {
                return width
            } else {
                return width / 2
            }
        }
    }
    
    
    //MARK: - BODY
    var body: some View {
        
        Button(action: {
            withAnimation(.easeInOut) {
                
                showingImageViewer.toggle()
                fullScreenPresented.toggle()
                
                //For Page Tab View Automatic scrolling...
                selectedImageID = images[index]
                
                
            }
        }) {
            ZStack{
                
                //Showing only Four Grids...
                
                if index <= 3 {
                    KFImage(URL(string: images[index].trimmingCharacters(in: .whitespaces)))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: getWidth(index: index), height: images.count == 1 ? getWidth(index: index) : 120)
                        .cornerRadius(12)
                }
                
                if images.count > 4 && index == 3 {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.3))
                    
                    let remainingImages = images.count - 4
                    
                    Text("+\(remainingImages)")
                        .font(.custom(K.Font.sfUITextBold, size: 20))
                        .foregroundColor(.white)
                }
                
            }
        }
        .fullScreenCover(isPresented: $fullScreenPresented) {
            ImageView(selectedImageID: $selectedImageID, images: .constant(images), showImageViewer: $showingImageViewer)
        }
    }
}

//struct GridImageView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        ImagesGridView()
//            .previewLayout(.fixed(width: 270, height: 400))
//    }
//}


// entending View to get screen size

extension View {
    
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
}
