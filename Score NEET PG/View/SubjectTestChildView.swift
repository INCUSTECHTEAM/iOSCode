//
//  SubjectTestChildView.swift
//  Score NEET PG
//
//  Created by Rahul on 14/04/23.
//

import SwiftUI

//MARK: Current Subject Var

var currentSubjectTestFor = ""

struct SubjectTestChildView: View {
    
    @ObservedObject var vm: MockTestViewModel
    var currentScreen: String
    @State var isPresentedPaymentScreen = false
    @StateObject var storeManager = StoreManager()
    
    var body: some View {
        ZStack {
        
            VStack {
                List {
                    ForEach(vm.subjectTests.indices, id: \.self) { index in
                        SubjectTestCellView(subject: vm.subjectTests[index], isTrial: index == 0 ? true : false)
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
                        if self.currentScreen == "subject" {
                            self.vm.getSubjectTests()
                        } else if self.currentScreen == "usmle1" {
                            //byPassBaseURL is added to use uslme url in neet pg
                            self.vm.getQBStep1()
                            K.byPassBaseURL = K.usmleStep1URL
                        } else if self.currentScreen == "usmle2" {
                            self.vm.getQBStep2()
                            K.byPassBaseURL = K.usmleStep2URL
                        }
                    }
                    
                    
                }
                .onAppear {
                    currentSubjectTestFor = currentScreen
                }
            }
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            
            if currentScreen == "subject" {
                Text("Sorry, No Subject Test Available")
                    .font(.custom(K.Font.sfUITextRegular, size: 15))
                    .foregroundColor(.textColor)
                    .opacity(vm.subjectTests.isEmpty && vm.isLoading == false ? 1 : 0)
            } else  {
                Text("Sorry, No Practice Test Available")
                    .font(.custom(K.Font.sfUITextRegular, size: 15))
                    .foregroundColor(.textColor)
                    .opacity(vm.subjectTests.isEmpty && vm.isLoading == false ? 1 : 0)
            }
            
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
 struct SubjectTestChildView_Previews: PreviewProvider {
 static var previews: some View {
 SubjectTestChildView()
 }
 }
 */
