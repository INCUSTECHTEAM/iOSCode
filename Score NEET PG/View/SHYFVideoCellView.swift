//
//  SHYFVideoCellView.swift
//  Score MLE
//
//  Created by Manoj kumar on 02/08/22.
//

import SwiftUI

struct SHYFVideoCellView: View {
    // MARK: - PROPERTIES
    
    var shyfRightWrongQuestion: ShyfRightWrongQuestion?
    
    // MARK: - BODY
    var body: some View {
        HStack {
            
            Image(systemName: "play.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.white)
                .padding(.leading)
                .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(shyfRightWrongQuestion?.questionName ?? "Rahul")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.trailing, 60)
            } //: VSTACK
            .padding(10)
            
            Spacer()
        } //: HSTACK
        .background(Color.cellLightGreyColor).cornerRadius(10)
    }
}

struct SHYFVideoCellView_Previews: PreviewProvider {
    static var previews: some View {
        SHYFVideoCellView()
            .previewLayout(.sizeThatFits)
    }
}
