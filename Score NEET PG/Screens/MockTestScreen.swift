//
//  MockTestScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 30/11/22.
//

import SwiftUI

struct MockTestScreen: View {
    //MARK: - PROPERTIES
    
    @ObservedObject var mockTestVM: MockTestViewModel = MockTestViewModel()
    @State private var isPresentedPaymentScreen = false
    @StateObject var storeManager = StoreManager()
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                CustomInlineNavigationBar(name: "Mock Test")
                
                VStack(spacing: 0) {
                    TopTabView(tabs: mockTestVM.mockTestDataModel.tabs, selectedTab: $mockTestVM.mockTestDataModel.selectedTab)
                    
                    //Divider()
                } // HEADER
                
                
                List {
                    ForEach(mockTestVM.mockTestDataModel.selectedTab == 0 ? mockTestVM.mockTestDataModel.mockTests.indices : mockTestVM.mockTestDataModel.subjectTests.indices, id: \.self) { index in
                        if mockTestVM.mockTestDataModel.selectedTab == 0 {
                            GrandTestCellView(mockTestResponseElement: mockTestVM.mockTestDataModel.mockTests[index], isTrial: index == 0 ? true : false)
                                .onTapGesture {
                                    if paymentStatus == false && !(index == 0) {
                                        isPresentedPaymentScreen = true
                                    }
                                }
                                .listRowInsets(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                        } else {
                            SubjectTestCellView(subject: mockTestVM.mockTestDataModel.subjectTests[index], isTrial: index == 0 ? true : false)
                                .onTapGesture {
                                    if paymentStatus == false && !(index == 0) {
                                        isPresentedPaymentScreen = true
                                    }
                                }
                                .listRowInsets(.init(top: 5, leading: 10, bottom: 10, trailing: 5))
                        }
                        
                    }
                    .listRowBackground(Color.backgroundColor)
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
                .onAppear {
                    mockTestVM.getUserDetails()
                    mockTestVM.getSubjectTests()
                }
                
                Spacer()
                
            } //: VSTACK
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            
            
            
            if self.mockTestVM.mockTestDataModel.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
        }  //: ZSTACK
        .fullScreenCover(isPresented: $isPresentedPaymentScreen, content: {
            PaymentScreen(storeManager: storeManager)
        })
        
    }
}

struct MockTestScreen_Previews: PreviewProvider {
    static var previews: some View {
        MockTestScreen()
    }
}
