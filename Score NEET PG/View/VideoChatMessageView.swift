//
//  VideoChatMessageView.swift
//  Score MLE
//
//  Created by Manoj kumar on 02/08/22.
//

import SwiftUI
import Kingfisher

struct VideoChatMessageView: View {
    // MARK: - PROPERTIES
    
    var chat: ChatBotElement
    @Binding var userIcon: String
    
    @State var item: Item?
    
    //MARK: - FUNCTIONS
    
    private func getVideoURL(vimeoId: String) {
        VimeoManager.shared.getVideoURL(vimeoId: vimeoId) { result in
            switch result {
            case .success(let url):
                item = Item(image: url)
            case .failure(_):
                break
            }
        }
    }
    
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
            
            VStack {
                Image(K.Image.videoDemo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .padding(.bottom, -20)
                
                Button(action: {
                    getVideoURL(vimeoId: chat.custom?.video?.stringValue ?? "")
                }) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.white)
                            .font(.custom(K.Font.sfUITextBold, size: 28))
                        
                        Text("Play Video")
                            .font(.custom(K.Font.sfUITextBold, size: 18))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.trailing)
                    }
                }
                .padding(.top, 0)
                .frame(width: 180)
                .modifier(ButtonRectangleModifier())
                .fullScreenCover(item: $item) { itemsss in
                    AutoRotate(url: URL(string: itemsss.image)!)
                }
                
                
            }
            
            
            Spacer()
        }
        .padding(.bottom)
    }
}

//struct VideoChatMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoChatMessageView()
//    }
//}
