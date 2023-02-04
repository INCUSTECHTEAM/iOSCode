//
//  GraphView.swift
//  Score MLE
//
//  Created by ios on 03/08/22.
//

import SwiftUI

struct GraphView: View {
    
    // MARK: - PROPERTIES
    
    var name: String
    var width: CGFloat
    var height: CGFloat
    var borderColor: Color
    var color: Color
    var count: String
    var fontSize: CGFloat
    
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: width, height: height)
                .foregroundColor(color)
                .border(borderColor)
                .overlay {
                    Text(name)
                        .font(.custom(K.Font.sfUITextRegular, size: fontSize))
                        .minimumScaleFactor(0.6) // value is up to you
                        .lineLimit(1)

                }
            
            Text(count)
                .font(.custom(K.Font.sfUITextRegular, size: fontSize))
            Spacer()
        }
    }
}

//struct GraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphView()
//    }
//}
