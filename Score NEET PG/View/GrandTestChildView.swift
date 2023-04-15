//
//  GrandTestChildView.swift
//  Score NEET PG
//
//  Created by Rahul on 14/04/23.
//

import SwiftUI

struct GrandTestChildView: View {
    
    @ObservedObject var vm: MockTestViewModel
    @State var isPresentedPaymentScreen = false
    @StateObject var storeManager = StoreManager()
    
    var body: some View {
        
        ZStack {
            VStack {
                List {
                    ForEach(vm.mockTests.indices, id: \.self) { index in
                        GrandTestCellView(mockTestResponseElement: vm.mockTests[index], isTrial: index == 0 ? true : false)
                            .onTapGesture {
                                if paymentStatus == false && !(index == 0) {
                                    isPresentedPaymentScreen = true
                                }
                            }
                            .listRowInsets(.none)
                            .listRowBackground(Color.backgroundColor)
                            .listRowSeparator(.hidden)
                        
                    }
                }
                .listStyle(.plain)
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                        self.vm.getMockTests()
                    }
                    
                }
            }
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            
            Text("Sorry, No Questions Available")
                .font(.custom(K.Font.sfUITextRegular, size: 15))
                .foregroundColor(.textColor)
                .opacity(vm.mockTests.isEmpty && vm.isLoading == false ? 1 : 0)
            
            if self.vm.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
        }
        .fullScreenCover(isPresented: $isPresentedPaymentScreen, content: {
            PaymentScreen(storeManager: storeManager)
        })
        
    }
}
/*
struct GrandTestChildView_Previews: PreviewProvider {
    static var previews: some View {
        GrandTestChildView()
    }
}
*/
