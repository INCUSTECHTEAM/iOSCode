//
//  SubscriptionView.swift
//  Score MLE
//
//  Created by Manoj kumar on 05/08/22.
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    
    @State private var paymentSuccess = false
    @State private var isPresentedPaymentScreen = false
    let productID = "com.vongo.score.MLE.yearly.subscription"
    
    @StateObject var storeManager = StoreManager()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            Image("pay_online-1")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding(.bottom)
            Text("Pay now for full access.")
                .font(.custom(K.Font.sfUITextRegular, size: 20))
                .foregroundColor(.textColor)
            
            
            Button(action: {

                isPresentedPaymentScreen.toggle()


            }) {
                Text("Pay")
                    .modifier(ButtonTextModifier())
                    .frame(width: 120)
            }
            .modifier(ButtonRectangleModifier())
            
            Spacer()
            
        }
        .fullScreenCover(isPresented: $isPresentedPaymentScreen, content: {
            PaymentScreen(storeManager: storeManager)
        })
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
