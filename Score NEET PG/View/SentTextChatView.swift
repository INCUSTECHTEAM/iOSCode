//
//  SentTextChatView.swift
//  Score MLE
//
//  Created by Manoj kumar on 01/08/22.
//

import SwiftUI
import Kingfisher

struct SentTextChatView: View {
    // MARK: - PROPERTIES
    
    var chat: ChatBotElement
    @State var userImage: String = ""
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Spacer()
            Text(chat.text ?? "")
                .font(.custom(K.Font.sfUITextBold, size: 18))
                .padding(7)
                .foregroundColor(.textColor)
                .background(Color.white)
                .cornerRadius(10, corners: [.bottomLeft, .bottomRight, .topLeft])
                .padding(.leading, 16)
                .padding(.bottom, 10)
            
            VStack {
                 
                    KFImage(URL(string: userImage) ?? URL(string: "https://vongo-chatbot.s3.ap-south-1.amazonaws.com/Asset_9500x.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAYMW7FB2HE6ZFEL4V%2F20220729%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20220729T192625Z&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Signature=91076c0dd53e0285589942fb364223cd920f8a420a23e02bd6df2d5094222c1d"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .cornerRadius(30)
                        .padding(10)
                        .padding(.trailing)
                        
                
                Spacer()
            }
        }
        .onAppear {
            
            guard let userImage = UserDefaults.standard.string(forKey: UserDetailsKey.image) else {
                return
            }
            self.userImage = userImage
        }
    }
}


// MARK: - PREVIEW
struct SentTextChatView_Previews: PreviewProvider {
    static var previews: some View {
        SentTextChatView(chat: ChatBotElement(recipientID: "1", custom: nil, image: nil, text: "Text", buttons: nil))
            .previewLayout(.sizeThatFits)
    }
}
