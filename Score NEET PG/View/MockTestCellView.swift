//
//  MockTestCellView.swift
//  Score MLE
//
//  Created by Manoj kumar on 03/08/22.
//

import SwiftUI

struct MockTestCellView: View {
    //MARK : - PROPERTIES
    
    var mockTest: MockTestElement
    
    //MARK :- BODY
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(mockTest.testName)
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

struct MockTestCellView_Previews: PreviewProvider {
    static var previews: some View {
        MockTestCellView(mockTest: MockTestElement(testName: "Mock Test", testID: 1))
            .previewLayout(.sizeThatFits)
    }
}
