//
//  TypingDotView.swift
//  Score MLE
//
//  Created by Manoj kumar on 02/08/22.
//

import SwiftUI
import Kingfisher

struct TypingDotView: View {
    // MARK: - PROPERTIES
    
    @Binding var userIcon: String
    
    // MARK: - BODY
    var body: some View {
        HStack {
            VStack {
                
                
                KFImage(URL(string: userIcon) ?? URL(string: "https://vongo-chatbot.s3.ap-south-1.amazonaws.com/Asset_9500x.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYMW7FB2HE6ZFEL4V%2F20220729%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20220729T192625Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Signature=91076c0dd53e0285589942fb364223cd920f8a420a23e02bd6df2d5094222c1d"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .cornerRadius(30)
                    .background(Color.textColor.cornerRadius(30))
                    .padding(.leading)
                
                Spacer()
            }
            
            GifImage("typingDot")
                .scaledToFit()
                .background(Color.backgroundColor)
                .frame(width: 118, height: 75, alignment: .center)
                .padding(.bottom, 10)
                
                
            Spacer()
        }
    }
}

struct TypingDotView_Previews: PreviewProvider {
    static var previews: some View {
        TypingDotView(userIcon: Binding.constant(""))
    }
}
