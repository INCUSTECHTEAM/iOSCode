//
//  ReceiveTextChatView.swift
//  Score MLE
//
//  Created by Manoj kumar on 01/08/22.
//

import SwiftUI
import Kingfisher

struct ReceiveTextChatView: View {
    
    @Binding var userIcon: String
    var chat: ChatBotElement
    
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
            
            Text(chat.text ?? "")
                .font(.custom(K.Font.sfUITextBold, size: 18))
                .foregroundColor(.textColor)
                .padding(7)
                .background(Color.lightGreenColor)
                .cornerRadius(10, corners: [.topRight, .bottomLeft, .bottomRight])
                .padding(.trailing, 16)
                .padding(.bottom, 10)
            Spacer()
        }
        .padding(.vertical, 15)
    }
}

//struct ReceiveTextChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReceiveTextChatView()
//    }
//}
