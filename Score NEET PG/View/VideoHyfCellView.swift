//
//  SubjectCellView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 18/08/22.
//

import SwiftUI

struct VideoHyfCellView: View {
    //MARK: - PROPERTIES
    
    var video: HyfElement
    var cellNumber = ""
    var isTrial: Bool? = false
   
    
    //MARK: - BODY
    var body: some View {
        HStack {
            
            Image(systemName: paymentStatus && !isTrailSessions ? "play.circle.fill" : isTrial! ? "play.circle.fill" : "lock.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding()
            
            Text(video.fact)
                .foregroundColor(.textColor)
                .font(.custom(K.Font.sfUITextRegular, size: 18))
                .padding(.vertical)
            
            Spacer()
        }
        
        .background(Color.cellLightGreyColor).cornerRadius(10)
        
    }
}

struct VideoHyfCellView_Previews: PreviewProvider {
    static var previews: some View {
        VideoHyfCellView(video: HyfElement(id: 1, tag: "22", fact: "33"))
            .previewLayout(.sizeThatFits)
    }
}
