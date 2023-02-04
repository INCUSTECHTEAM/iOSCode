//
//  SHYFCellView.swift
//  Score MLE
//
//  Created by ios on 30/07/22.
//

import SwiftUI

struct SHYFCellView: View {
    // MARK: - PROPERTIES
    
    var shyfRightWrongQuestion: ShyfRightWrongQuestion?
    
    // MARK: - BODY
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(shyfRightWrongQuestion?.questionName ?? "")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.trailing, 60)
            } //: VSTACK
            .padding()
            
            Spacer()
        } //: HSTACK
        .background(Color.cellLightGreyColor).cornerRadius(10)
    }
}

//struct SHYFCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        SHYFCellView()
//            .previewLayout(.sizeThatFits)
//    }
//}
