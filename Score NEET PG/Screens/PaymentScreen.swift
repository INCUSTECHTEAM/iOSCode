//
//  PaymentScreen.swift
//  Score MLE
//
//  Created by Manoj kumar on 04/08/22.
//

import SwiftUI
import StoreKit

struct PaymentScreen: View {
    // MARK: - PROPERTIES
    
    //let paymentHandler = PaymentHandler()
    @State private var paymentSuccess = false
    let productID = "com.vongo.score.MLE.1.year.subscription"
    
    @StateObject var storeManager: StoreManager
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - FUNCTIONS
    
    func buySubscription() {
        if SKPaymentQueue.canMakePayments() {
            //Can make payments
            
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
            
        } else {
            //Can't make payments
            print("User can't make payments")
        }
    }
    
    
    
    // MARK: - BODY
    var body: some View {
        VStack {
            
            CustomNavigationView()
                .padding(15)
            
            Spacer()
            
            VStack {
                GroupBox {
                    HStack {
                        Image(systemName: "play.tv")
                            .foregroundColor(.textColor)
                            .frame(width: 24, height: 24)
                        Text("Full Access")
                            .foregroundColor(.textColor)
                            .font(.custom(K.Font.sfUITextBold, size: 22))
                    }
                    .padding(.bottom)
                    
                    Text("Bot Tutor Video, Quiz Flashcard Courses Podcast, Notes, Mock Test")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 18))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.bottom, 15)
                    
                    Text("Rs 17900 Only")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextBold, size: 24))
                        .padding(.bottom, 15)
                    
                    Text("per Year Subscription")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 18))
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        
                        if !storeManager.myProducts.isEmpty {
                            storeManager.purchaseProduct(product: storeManager.myProducts[0])
                        }
                        
//                        fetchPackage { package in
//                            self.purchase(package: package)
//                        }
                        
                        
                    }) {
                        Text("Pay")
                            .modifier(ButtonTextModifier())
                            .frame(width: 120)
                    }
                    .modifier(ButtonRectangleModifier())
                    
                    
//                    Button(action: {
//                        restorePurchases()
//                    }) {
//                        Text("Restore Subscription")
//                            .font(.custom(K.Font.sfUITextRegular, size: 14))
//                            .foregroundColor(.textColor)
//                    }
                    
                }
                .padding()
                .groupBoxStyle(ColoredGroupBox())
                //.offset(y: -30)
                
                HStack {
                    Spacer()
                    Text("Include All Taxes")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                        .padding(.horizontal)
                        .offset(y: -20)
                }
                    
                
            }
            .offset(y: -30)
            
            
            
            
            Spacer()
            
        }
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
           
            storeManager.getProducts(productIDs: [productID])
            SKPaymentQueue.default().add(storeManager)
            
        })
        .onReceive(storeManager.didSendRequest) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        
    }
}

struct PaymentScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaymentScreen(storeManager: StoreManager())
    }
}
