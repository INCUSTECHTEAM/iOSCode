//
//  VideoListScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 18/08/22.
//

import SwiftUI

struct VideoListScreen: View {
    
    //    init() {
    //        UINavigationBar.appearance().backgroundColor = .clear
    //    }
    
    //MARK: - PROPERTIES
    
    @State private var videos = Hyf()
    @State private var searchText = ""
    @State private var isLoading = false
    var subjectID: String = ""
    @State var vimeoId: String = ""
    @State var isVideoPlayerPresented = false
    @State var firstVideo: HyfElement?
    
    @State private var isPresentedPaymentScreen = false
    
    @StateObject var storeManager = StoreManager()
    @State var videoURL: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var filteredvideos: Hyf {
        if searchText.isEmpty {
            return videos
        } else {
            return videos.filter { (video: HyfElement) -> Bool in
                return video.fact.localizedCaseInsensitiveContains(searchText) || video.tag.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.backward")
                .tint(.textColor)
                .frame(width: 8, height: 8, alignment: .center)
                .padding(12)
                .background(
                    Color.gray.opacity(0.3)
                )
                .cornerRadius(8)
        })
    }
    
    
    //MARK: - FUNCTIONS
    
 
    
    private func getVideos() {
        isLoading = true
        NetworkManager.shared.getHyfVideo(subjectID: subjectID) { results in
            isLoading = false
            switch results {
            case .success(let videos):
                self.videos = videos
                self.firstVideo = videos.first
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getVideoURL(vimeoId: String) {
        isLoading = true
        VimeoManager.shared.getVideoURL(vimeoId: vimeoId) { result in
            isLoading = false
            switch result {
            case .success(let url):
                videoURL = url
                isVideoPlayerPresented = true
            case .failure(_):
                break
            }
        }
    }
    
    private func getVideoData(hyfID: String) {
        isLoading = true
        NetworkManager.shared.getVideoData(subjectID: subjectID, hyfID: hyfID) { result in
            isLoading = false
            switch result {
            case .success(let data):
                self.vimeoId = data.first?.video ?? ""
                getVideoURL(vimeoId: data.first?.video ?? "")
                
                //self.isVideoPlayerPresented = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    //MARK: - BODY
    var body: some View {
        
        ZStack {
            List {
                Section(content: {
                    ForEach(filteredvideos.indices, id: \.self) { index in
                        VideoHyfCellView(video: filteredvideos[index], cellNumber: "\(index + 1)", isTrial: filteredvideos[index].id == firstVideo?.id ? true : false)
                            .onTapGesture {
                                if paymentStatus && !isTrailSessions {
                                    getVideoData(hyfID: filteredvideos[index].id.description)
                                } else {
                                    if filteredvideos[index].id == firstVideo?.id {
                                        getVideoData(hyfID: filteredvideos[index].id.description)
                                    } else {
                                        isPresentedPaymentScreen = true
                                    }
                                }
                            }
                    }
                    .listRowBackground(Color.backgroundColor)
                    .listRowSeparator(.hidden)
                }, header: {
                    if !filteredvideos.isEmpty {
                        HStack {
                            Text(filteredvideos.count > 1 ? "\(filteredvideos.count) Videos" : "\(filteredvideos.count) Video")
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextRegular, size: 18))
                            
                            Spacer()
                        }
                        .padding(10)
                        .listRowInsets(EdgeInsets())
                        .background(Color.backgroundColor)
                    }
                })
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .navigationTitle("Videos")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .onAppear {
                getVideos()
            }
            
            
            if isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                //.background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
        }
        .fullScreenCover(isPresented: $isVideoPlayerPresented) {
            AutoRotate(url: URL(string: videoURL)!)
        }
        .fullScreenCover(isPresented: $isPresentedPaymentScreen, content: {
            PaymentScreen(storeManager: storeManager)
        })
    }
}

struct VideoListScreen_Previews: PreviewProvider {
    static var previews: some View {
        VideoListScreen(vimeoId: "1")
    }
}
