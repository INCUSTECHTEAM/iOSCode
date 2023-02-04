//
//  RightWrongQuestionCellView.swift
//  Score MLE
//
//  Created by ios on 30/07/22.
//

import SwiftUI

struct RightWrongQuestionCellView: View {
    // MARK: - PROPERTIES
    
    var rightWrongQueston: RightWrongQuestion?
    
    // MARK: - BODY
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(rightWrongQueston?.questionName ?? "")
                    .foregroundColor(.textColor)
                    .font(.custom(K.Font.sfUITextRegular, size: 16))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 60)
                
                Text("Correct Answer: \(rightWrongQueston?.answer ?? "")")
                    .foregroundColor(.textColor.opacity(0.8))
                    .font(.custom(K.Font.sfUITextRegular, size: 14))
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
            } //: VSTACK
            .padding()
            
            Spacer()
        } //: HSTACK
        .background(Color.cellLightGreyColor).cornerRadius(10)
    }
}

// MARK: - PREVIEW
struct RightWrongQuestionCellView_Previews: PreviewProvider {
    static var previews: some View {
        RightWrongQuestionCellView()
            .previewLayout(.sizeThatFits)
    }
}
