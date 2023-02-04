//
//  ImagesGridView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 13/08/22.
//

import SwiftUI
import Kingfisher

struct ImagesGridView: View {
    
    var images: [String]
    @Binding var showImageViewer: Bool
    @Binding var selectedImageID: String
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            ForEach(images.indices, id: \.self) { index in
                
                GridImageView(images: images, index: index, showingImageViewer: $showImageViewer, selectedImageID: $selectedImageID)
                
            }
        }
    }
}


//struct ImagesGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagesGridView()
//            .previewLayout(.fixed(width: 280, height: 300))
//    }
//}
