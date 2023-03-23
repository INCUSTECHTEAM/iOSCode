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
    
    @ObservedObject var inAppPurchase = InAppPurchaseManager.shared
    
    //let paymentHandler = PaymentHandler()
    @State private var paymentSuccess = false
    let productID = "com.vongo.score.MLE.1.year.subscription"
    
    @StateObject var storeManager: StoreManager
    
    @Environment(\.presentationMode) var presentationMode
    
    let courseEnvironment = CourseEnvironment.shared
    
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
        ZStack {
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
                        
                        if courseEnvironment.checkSelectedCourse() == Courses.NEETPG.rawValue {
                            Text("Bot Tutor Video, Quiz Flashcard Courses Podcast, Notes, Mock Test")
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextRegular, size: 18))
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .padding(.bottom, 15)
                        } else if courseEnvironment.checkSelectedCourse() == Courses.Nursing.rawValue {
                            Text("""
10000 MCQs Subject wise tests
15000 High Yield Facts Notes of 13 Nursing Subjects
AI Tutor 20000 MCQs to test knowledge of Notes
30 Nursing officer Exam Grand tests
""")
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextRegular, size: 18))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 15)
                        } else {
                            Text("""
10000 MCQs Subject wise tests
15000 High Yield Facts Notes of USMLE STEPS 1 Subjects
AI Tutor 20000 MCQs to test knowledge of Notes
USMLE STEPS officer Exam Grand tests
""")
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextRegular, size: 18))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 15)
                        }
                        
                        
                        if courseEnvironment.checkSelectedCourse() == Courses.NEETPG.rawValue {
                            Text("Rs 17900 Only")
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextBold, size: 24))
                                .padding(.bottom, 15)
                        } else if courseEnvironment.checkSelectedCourse() == Courses.Nursing.rawValue {
                            Text("Rs 6500 Only")
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextBold, size: 24))
                                .padding(.bottom, 15)
                        } else {
                            Text("Rs 8900 Only")
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextBold, size: 24))
                                .padding(.bottom, 15)
                        }
                        
                        
                        Text("per Year Subscription")
                            .foregroundColor(.textColor)
                            .font(.custom(K.Font.sfUITextRegular, size: 18))
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            
//                            if !storeManager.myProducts.isEmpty {
//                                storeManager.purchaseProduct(product: storeManager.myProducts[0])
//                            }
                            self.inAppPurchase.isLoading = true
                            if courseEnvironment.checkSelectedCourse() == Courses.NEETPG.rawValue {
                                self.inAppPurchase.purchase(product: inAppPurchase.products[0])
                            } else if courseEnvironment.checkSelectedCourse() == Courses.Nursing.rawValue {
                                self.inAppPurchase.purchase(product: inAppPurchase.products[1])
                            } else {
                                self.inAppPurchase.purchase(product: inAppPurchase.products[2])
                            }
                            
                            
                        }) {
                            Text("Pay")
                                .modifier(ButtonTextModifier())
                                .frame(width: 120)
                        }
                        .modifier(ButtonRectangleModifier())
                        
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
            } //: VSTACK
            
            
            if inAppPurchase.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
        } //: ZSTACK
        
    }
}

struct PaymentScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaymentScreen(storeManager: StoreManager())
    }
}
