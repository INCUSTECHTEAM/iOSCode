//
//  PPTHyfCellView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 27/09/22.
//

import SwiftUI

struct PPTHyfCellView: View {
    //MARK: - PROPERTIES
    
    var ppt: PPTListElement
    var isTrial: Bool? = false
    
    //MARK: - BODY
    var body: some View {
        HStack {
            
            if paymentStatus && !isTrailSessions {
                Image("tecaher")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    //.foregroundColor(.white)
                    .padding()
            } else {
                
                if isTrial! {
                    Image("tecaher")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        //.foregroundColor(.white)
                        .padding()
                } else {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .padding()
                }
               
            }
            
            Text(ppt.fact ?? "")
                .foregroundColor(.textColor)
                .font(.custom(K.Font.sfUITextRegular, size: 18))
                .padding(.vertical)
            
            Spacer()
        }
        .background(Color.cellLightGreyColor).cornerRadius(10)
    }
}

struct PPTHyfCellView_Previews: PreviewProvider {
    static var previews: some View {
        PPTHyfCellView(ppt: PPTListElement(id: 1, tag: "22", fact: "@2"))
            .previewLayout(.sizeThatFits)
    }
}
