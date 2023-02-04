//
//  PracticeScreen.swift
//  Score MLE
//
//  Created by ios on 29/07/22.
//

import SwiftUI
import Kingfisher
import Combine

var paymentStatus = false
var isTrailSessions = false

struct PracticeScreen: View {
    // MARK: - PROPERTIES
    
    @Binding var reload: Bool
    @State private var payload = ""
    @State private var userIcon = ""
    @State private var chatBot: ChatBot = []
    @State private var chatButtons = [ChatBotButton]()
    @State var isLoading = false
    @State var isPresentedVideoFullScreen = false
    @State var isPresentedPaymentScreen = false
    @State var fullScreenImage = ""
    @State var isTyping: Bool = false
    @State var session: Int = 0
    @State var images: [String] = []
    @State var showImageViewer = false
    @State var selectedImageID: String = ""
//    @State var apiCallingCount = 0
//    @State var appearCount = 0
    
    
    @StateObject var storeManager = StoreManager()
    @StateObject var updateManager = CheckUpdate()
    
    @State var columns = Array(repeating: GridItem(.flexible(minimum: 30)), count: 3)
    
    // MARK: - FUNCTIONS
    
    func getSession() {
        
        NetworkManager.shared.getSession { result in
            switch result {
            case .success(let session):
                if session <= 5 {
                    isTrailSessions = true
                    paymentStatus = true
                    getChatBotResponse(payload: "/restart")
                } else {
                    isTrailSessions = false
                    paymentStatus = false
                    getUserDetails()
                }
                self.session = session
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func getUserDetails() {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        isLoading = true
        
        //        NetworkManager.shared.getUserDetails(mobileNumber: phoneNumber) { result in
        //            switch result {
        //            case .success(let data):
        //
        //                DispatchQueue.main.async {
        //                    UserSession.userSessionInstance.setSubscriptionExpiry(expiryDate: data.userLst?.first?.subscriptionExpiration ?? "")
        //                    self.isLoading = false
        //
        //
        //                    if data.userLst?.first?.userComment == "Active" {
        //                        paymentStatus = true
        //                        getChatBotResponse(payload: "/restart")
        //                    } else {
        //
        //                        if UserSession.userSessionInstance.getSubscriptionStatus() {
        //                            paymentStatus = true
        //                            getChatBotResponse(payload: "/restart")
        //                        } else {
        //                            paymentStatus = false
        //                            getChatBotResponse(payload: "/restart")
        //                            print("Need to purchase subscription")
        //                        }
        //
        //
        //
        //                    }
        //
        //                }
        //            case .failure(let error):
        //                self.isLoading = false
        //
        //                print("failure \(error.localizedDescription)")
        //            }
        //        }
        
        
        NetworkManager.shared.getUser(mobileNumber: phoneNumber) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    UserSession.userSessionInstance.setSubscriptionExpiry(expiryDate: data.paymentExpiryDate ?? "")
                    self.isLoading = false
                    
                    
                    if data.paid == true {
                        paymentStatus = true
                        getChatBotResponse(payload: "/restart")
                    } else {
                        
                        if UserSession.userSessionInstance.getSubscriptionStatus() {
                            paymentStatus = true
                            getChatBotResponse(payload: "/restart")
                        } else {
                            paymentStatus = false
                            getChatBotResponse(payload: "/restart")
                            print("Need to purchase subscription")
                        }
                        
                        
                        
                    }
                    
                }
            case .failure(let error):
                self.isLoading = false
                
                print("failure \(error.localizedDescription)")
            }
        }
        
    }
    
    func getChatBotUserIcon() {
        NetworkManager.shared.getChatBotFavIcon { result in
            switch result {
            case .success(let data):
                userIcon = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getChatBotResponse(payload: String) {
        
        guard !updateManager.isShowUpdateAlert else {
            return
        }
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        guard let firstname = UserDefaults.standard.string(forKey: UserDetailsKey.firstname) else { return }
        let lastname = UserDefaults.standard.string(forKey: UserDetailsKey.lastname) ?? ""
        
        //        chatBot.append(ChatBotElement(recipientID: phoneNumber, custom: nil, image: nil, text: nil, buttons: nil, isTyping: true))
        
        isLoading = true
        
        
        let parameters: [String : Any] = [
            "metadata" : [
                "mobile" : phoneNumber,
                "name" : firstname + " " + lastname,
                "payment_status" : paymentStatus
            ],
            "message" : payload,
            "sender" : phoneNumber
        ]
        
        NetworkManager.shared.getChatBotMessages(parameters: parameters) { result in
            
            isLoading = false
           // apiCallingCount += 1
            
            switch result {
            case .success(let data):
                
                DispatchQueue.main.async {
                    withAnimation {
                        
                        chatBot = data
                        //                        chatBot.removeAll(where: { $0.isTyping == true })
                        //                        chatBot.append(contentsOf: data)
                        chatButtons = data.compactMap({ $0.buttons }).first ?? []
                    }
                    if payload == "/restart" {
                        getChatBotResponse(payload: "/start")
                        
                    }
//                    if apiCallingCount > 1 {
//                        updateManager.showUpdate(withConfirmation: false)
//                    }
                    
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func sendChatBotResponse(payload: String) {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        guard let firstname = UserDefaults.standard.string(forKey: UserDetailsKey.firstname) else { return }
        let lastname = UserDefaults.standard.string(forKey: UserDetailsKey.lastname) ?? ""
        
        chatBot.append(ChatBotElement(recipientID: phoneNumber, custom: nil, image: nil, text: nil, buttons: nil, isTyping: true))
        
        
        let parameters: [String : Any] = [
            "metadata" : [
                "mobile" : phoneNumber,
                "name" : firstname + " " + lastname,
                "payment_status" : paymentStatus
            ],
            "message" : payload,
            "sender" : phoneNumber
        ]
        
        NetworkManager.shared.getChatBotMessages(parameters: parameters) { result in
            
            switch result {
            case .success(let data):
                
                DispatchQueue.main.async {
                    withAnimation {
                        chatBot.removeAll(where: { $0.isTyping == true })
                        chatBot.append(contentsOf: data)
                        chatButtons = data.compactMap({ $0.buttons }).first ?? []
                    }
                    if payload == "/restart" {
                        getChatBotResponse(payload: "/start")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Text("NEETPG AI Tutor")
                            .font(.custom(K.Font.sfUITextBold, size: 20))
                            .foregroundColor(.textColor)
                        Spacer()
                    } //: HSTACK
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        ForEach(chatBot, id: \.id) { chat in
                            
                            let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber)
                            
                            if chat.recipientID != phoneNumber {
                                //Send Message
                                SentTextChatView(chat: chat)
                            } else {
                                //receive
                                
                                if ((chat.custom?.gif) != nil) {
                                    KFAnimatedImage(URL(string: chat.custom?.gif?.link ?? "")!)
                                        .frame(width: 300)
                                        .frame(maxHeight: 300)
                                    
                                } else if chat.custom?.graph != nil {
                                    HStack {
                                        VStack {
                                            if let url = URL(string: userIcon) {
                                                KFImage(url)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 60, height: 60)
                                                    .cornerRadius(30)
                                                    .background(Color.textColor.cornerRadius(30))
                                                    .padding(.leading)
                                            }
                                            
                                            Spacer()
                                        }
                                        ChatGraphView(graph: chat.custom?.graph ?? [:])
                                    }
                                } else if chat.custom?.fullGraph != nil {
                                    
                                    FullGraphArrayView(graphs: chat.custom?.fullGraph ?? [], userIcon: userIcon)
                                    
                                } else if chat.image != nil {
                                    
                                    //ImageChatView(chat: chat, userIcon: $userIcon)
                                    
                                    HStack {
                                        
                                        VStack {
                                            if let url = URL(string: userIcon) {
                                                KFImage(url)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 60, height: 60)
                                                    .cornerRadius(30)
                                                    .background(Color.textColor.cornerRadius(30))
                                                    .padding(.leading)
                                            }
                                            
                                            Spacer()
                                        }
                                        
                                        
                                        ImagesGridView(images: chat.imageArray!, showImageViewer: self.$showImageViewer, selectedImageID: self.$selectedImageID)
                                        
                                        Spacer()
                                    }
                                        
                                    
                                    
                                } else if (chat.custom?.video != nil) {
                                    
                                    VideoChatMessageView(chat: chat, userIcon: $userIcon)
                                    
                                    
                                } else if chat.text != nil {
                                    ReceiveTextChatView(userIcon: $userIcon, chat: chat)
                                } else if chat.isTyping {
                                    TypingDotView(userIcon: $userIcon)
                                } else if chat.custom?.singleGraph != nil {
                                    
                                    FullGraphArrayView(graphs: [chat.custom!.singleGraph!], userIcon: userIcon)
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                            
                        }
                        .rotationEffect(.degrees(180))
                        
                        
                        
                        
                    } //: SCROLL
                    .rotationEffect(.degrees(180))
                    .onAppear {
                        
                        //appearCount += 1
                        
                        //if appearCount <= 1 {
                            getChatBotUserIcon()
                            getSession()
                        //}
                        
                        //getChatBotResponse(payload: "/restart")
                    }
                    .onDisappear {
//                        if appearCount > 1 {
//                            appearCount = 0
//                        }
                        chatBot.removeAll()
                        chatButtons.removeAll()
                    }
                    .onChange(of: reload) { _ in
                        
                        chatBot.removeAll()
                        chatButtons.removeAll()
                        
                        getChatBotUserIcon()
                        getSession()
                    }
                    
                    
                    if chatButtons.count > 6 {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 60)), count: 2), spacing: 5) {
                                ForEach(chatButtons, id: \.id) { item in
                                    BotButtonView(titleKey: item.title ?? "")
                                        .onTapGesture {
                                            chatButtons.removeAll()
                                            withAnimation {
                                                chatBot.append(ChatBotElement(recipientID: "123", custom: nil, image: nil, text: item.title, buttons: nil))
                                            }
                                            
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                                sendChatBotResponse(payload: item.payload?.stringValue ?? "/restart")
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                        .frame(maxHeight: 150)
                    } else if chatButtons.count == 1 {
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 60)), count: 1), spacing: 5) {
                            ForEach(chatButtons, id: \.id) { item in
                                BotButtonView(titleKey: item.title ?? "")
                                    .onTapGesture {
                                        chatButtons.removeAll()
                                        if item.payload?.stringValue == "/make_payment" {
                                            withAnimation {
                                                isPresentedPaymentScreen.toggle()
                                            }
                                        } else {
                                            withAnimation {
                                                chatButtons.removeAll()
                                                chatBot.append(ChatBotElement(recipientID: "123", custom: nil, image: nil, text: item.title, buttons: nil))
                                            }
                                            
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                                
                                                sendChatBotResponse(payload: item.payload?.stringValue ?? "/restart")
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        
                    } else if chatButtons.count == 2 {
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 60)), count: 2), spacing: 5) {
                            ForEach(chatButtons, id: \.id) { item in
                                BotButtonView(titleKey: item.title ?? "")
                                    .onTapGesture {
                                        chatButtons.removeAll()
                                        withAnimation {
                                            chatBot.append(ChatBotElement(recipientID: "123", custom: nil, image: nil, text: item.title, buttons: nil))
                                        }
                                        
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                            
                                            sendChatBotResponse(payload: item.payload?.stringValue ?? "/restart")
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    } else if chatButtons.count == 3 {
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 60)), count: 2), spacing: 10) {
                                ForEach(chatButtons, id: \.id) { item in
                                    BotButtonView(titleKey: item.title ?? "")
                                        .onTapGesture {
                                            chatButtons.removeAll()
                                            withAnimation {
                                                chatBot.append(ChatBotElement(recipientID: "123", custom: nil, image: nil, text: item.title, buttons: nil))
                                            }
                                            
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                                
                                                sendChatBotResponse(payload: item.payload?.stringValue ?? "/restart")
                                            }
                                        }
                                    
                                }
                                
                            }
                            .padding(.horizontal)
                            
                        }
                        .padding(.bottom, 10)
                        .frame(maxHeight: 80)
                        
                        
                    } else if chatButtons.count == 4 {
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 60)), count: 1), spacing: 10) {
                                ForEach(chatButtons, id: \.id) { item in
                                    BotButtonView(titleKey: item.title ?? "")
                                        .onTapGesture {
                                            chatButtons.removeAll()
                                            withAnimation {
                                                chatBot.append(ChatBotElement(recipientID: "123", custom: nil, image: nil, text: item.title, buttons: nil))
                                            }
                                            
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                                
                                                sendChatBotResponse(payload: item.payload?.stringValue ?? "/restart")
                                            }
                                        }
                                    
                                }
                                
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                        .frame(maxHeight: 100)
                        
                    } else if chatButtons.count == 5 {
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 60)), count: 1), spacing: 10) {
                                ForEach(chatButtons, id: \.id) { item in
                                    BotButtonView(titleKey: item.title ?? "")
                                        .onTapGesture {
                                            chatButtons.removeAll()
                                            withAnimation {
                                                chatBot.append(ChatBotElement(recipientID: "123", custom: nil, image: nil, text: item.title, buttons: nil))
                                            }
                                            
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                                
                                                sendChatBotResponse(payload: item.payload?.stringValue ?? "/restart")
                                            }
                                        }
                                    
                                }
                                
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                        .frame(maxHeight: 100)
                        
                    } else {
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 60)), count: 2), spacing: 5) {
                            ForEach(chatButtons, id: \.id) { item in
                                BotButtonView(titleKey: item.title ?? "")
                                    .onTapGesture {
                                        chatButtons.removeAll()
                                        withAnimation {
                                            chatBot.append(ChatBotElement(recipientID: "123", custom: nil, image: nil, text: item.title, buttons: nil))
                                        }
                                        
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                            
                                            sendChatBotResponse(payload: item.payload?.stringValue ?? "/restart")
                                        }
                                    }
                            }
                            
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        
                    }
                    
                    
                } //: VSTACK
                .fullScreenCover(isPresented: $isPresentedPaymentScreen, content: {
                    PaymentScreen(storeManager: storeManager)
                        .onDisappear {
                            chatBot.removeAll()
                            chatButtons.removeAll()
                            getSession()
                            getChatBotUserIcon()
                        }
                })
                .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
                
                
                if isLoading {
                    GeometryReader { proxy in
                        Loader()
                            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                    }
                    .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
                }
                
            } //: ZSTACK
            .navigationBarHidden(true)
            .alert("New Version Available", isPresented: $updateManager.isShowUpdateAlert) {
                Button(action: {
                    
                    guard let url = updateManager.url else {
                        return
                    }
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    
                    updateManager.showUpdate(withConfirmation: false)
                }) {
                    Text("Update")
                }
            } message: {
                Text("A new version of \(Text("Score NEET PG").font(.custom(K.Font.sfUITextBold, size: 14))) App is available. Please update to new version")
            }

        } //: NAVIGATION
        .environmentObject(updateManager)
    }
}

// MARK: - PREVIEW
struct PracticeScreen_Previews: PreviewProvider {
    static var previews: some View {
        PracticeScreen(reload: .constant(true))
    }
}

