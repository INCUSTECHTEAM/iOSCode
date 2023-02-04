//
//  PPTListView.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 26/09/22.
//

import SwiftUI

struct PPTListView: View {
    
    //MARK: - PROPERTIES
    @State private var pPTList = PPTList()
    @State private var searchText = ""
    @State private var isLoading = false
    @State var firstPPT: PPTListElement?
    @State private var isPPTPresented = false
    var subjectID: String = ""
    @State var webURL = ""
    @State private var isPresentedPaymentScreen = false
    
    @StateObject var storeManager = StoreManager()
    
    @Environment(\.presentationMode) var presentationMode
    
    var filteredPPTs: PPTList {
       if searchText.isEmpty {
            return pPTList
        } else {
            return self.pPTList.filter { (ppt: PPTListElement) -> Bool in
                return ppt.fact?.localizedCaseInsensitiveContains(searchText) ?? false || ppt.tag?.localizedCaseInsensitiveContains(searchText) ?? false
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
    
    private func getPPTs() {
        isLoading = true
        NetworkManager.shared.getHyfPPTList(subjectID: subjectID) { results in
            isLoading = false
            switch results {
            case .success(let ppts):
                self.pPTList = ppts
                self.firstPPT = ppts.first
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    private func getPPTData(hyfID: String) {
        isLoading = true
        NetworkManager.shared.getPPTData(subjectID: subjectID, hyfID: hyfID) { result in
            isLoading = false
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.webURL = data.first?.ppt ?? ""
                    isPPTPresented = true
                }
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
                    ForEach(filteredPPTs.indices, id: \.self) { index in
                        PPTHyfCellView(ppt: filteredPPTs[index], isTrial: filteredPPTs[index].id == firstPPT?.id ? true : false)
                            .onTapGesture {
                                if paymentStatus && !isTrailSessions {
                                    getPPTData(hyfID: filteredPPTs[index].id?.description ?? "")
                                } else {
                                    if filteredPPTs[index].id == firstPPT?.id {
                                        getPPTData(hyfID: filteredPPTs[index].id?.description ?? "")
                                    } else {
                                        isPresentedPaymentScreen = true
                                    }
                                }
                            }
                            
                    }
                    .listRowBackground(Color.backgroundColor)
                    .listRowSeparator(.hidden)
                }, header: {
                    if !filteredPPTs.isEmpty {
                        HStack {
                            Text(filteredPPTs.count > 1 ? "\(filteredPPTs.count) PPTs" : "\(filteredPPTs.count) PPT")
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
            .navigationTitle("PPT")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .onAppear {
                getPPTs()
            }
            
            
            if isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                //.background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
        }
        .fullScreenCover(isPresented: $isPPTPresented) {
            PPTScreen(webviewURL: webURL)
        }
        .fullScreenCover(isPresented: $isPresentedPaymentScreen, content: {
            PaymentScreen(storeManager: storeManager)
        })
    }
}

struct PPTListView_Previews: PreviewProvider {
    static var previews: some View {
        PPTListView()
    }
}
