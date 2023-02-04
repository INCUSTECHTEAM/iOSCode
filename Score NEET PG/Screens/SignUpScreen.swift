//
//  ContentView.swift
//  Score MLE
//
//  Created by ios on 28/07/22.
//

import SwiftUI
import CountryPicker
import Combine


struct SignUpScreen: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authentication: Authentication
    
    
    @ObservedObject var input = NumbersOnly()
    @State private var isTermsAccepted: Bool = false
    @State private var country: Country?
    @State private var showCountryPicker = false
    //@State private var isNavigateToOTP = false
    @State var isLoading = false
    @State private var action: Int? = 0
    @State var alertItem: AlertItem?
    
    
    // MARK: - FUNCTIONS
    
    private func phoneAuth() {
        guard input.value != "" else {
            return self.alertItem = AlertContext.invalidPhoneNumber
        }
        
        guard isTermsAccepted else {
            return self.alertItem = AlertContext.termsNotAccepted
        }
        
        isLoading = true
        AuthManager.shared.startAuth(phoneNumber: "+\(country?.phoneCode ?? "91")\(input.value)") { result, data  in
            switch result {
            case true:
                //isNavigateToOTP = true
                isLoading = false
                self.action = 1
            case false:
                isLoading = false
                alertItem = AlertItem(title: Text("Error"), message: Text(data ?? "Something went wrong"), dismissButton: .default(Text("Okay")))
            }
        }
        
    }
    
    //Function to keep text length in limits
    func limitText(_ upper: Int) {
        if input.value.count > upper {
            input.value = String(input.value.prefix(upper))
        }
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack {
                
                
                NavigationLink(destination: VerificationScreen(phoneNumber: input.value), tag: 1, selection: $action) {
                    EmptyView()
                }
                
                Image(K.Image.scoreLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180, alignment: .center)
                
                Spacer()
                    .frame(maxHeight: 80)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Sign Up")
                            .font(.custom(K.Font.sfUITextBold, size: 30))
                            .foregroundColor(.orangeColor)
                        
                        Spacer()
                    }
                    
                    Text("Please log in to continue")
                        .font(.custom(K.Font.sfUITextRegular, size: 16))
                        .foregroundColor(.textColor)
                        .padding(.bottom)
                    
                    //TEXTFIELD
                    
                    HStack {
                        Button(action: {
                            showCountryPicker = true
                        }) {
                            Image(systemName: "phone")
                                .foregroundColor(.orangeColor)
                            
                            Text("+\(country?.phoneCode ?? "91")")
                                .font(.custom(K.Font.sfUITextRegular, size: 16))
                                .foregroundColor(.textColor)
                        }
                        .sheet(isPresented: $showCountryPicker) {
                            CountryPicker(country: $country)
                        }
                        
                        TextField("", text: $input.value)
                            .placeholder(when: input.value.isEmpty) {
                                Text("Phone Number").foregroundColor(.textColor)
                            }
                            .font(.custom(K.Font.sfUITextRegular, size: 16))
                            .foregroundColor(.textColor)
                            .keyboardType(.decimalPad)
                            .onReceive(Just(input.value)) { _ in limitText(10) }
                        
                        
                    } //: HSTACK
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.clear)
                        //.stroke(Color.backgroundColor.opacity(0.7), lineWidth: 1)
                    )
                    .background(Color.gray.opacity(0.2).cornerRadius(20))
                    
                }
                .padding()
                
                //TERMS AND CONDITION
                HStack(spacing: 0) {
                    
                    //TERM BUTTON
                    Button(action: {
                        isTermsAccepted.toggle()
                    }) {
                        Image(systemName: isTermsAccepted ? "checkmark.square.fill" : "square")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(isTermsAccepted ? .orangeColor : .textColor)
                            .frame(width: 20, height: 20)
                    }
                    .padding(8)
                    
                    Text("By signing up, you agree to the our")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 12))
                    
                    +
                    Text("[Terms and Conditions](https://playscore.live/termsandconditionsofuse)")
                        .underline()
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 12))
                    +
                    Text(" and ")
                        .foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 12))
                    +
                    Text("[Privacy Policy](https://playscore.live/privacypolicy)")
                        .underline().foregroundColor(.textColor)
                        .font(.custom(K.Font.sfUITextRegular, size: 12))
                    
                    Spacer()
                    
                } //: HSTACK
                .padding(.horizontal)
                
                
                Button(action: {
                    
                    hideKeyboard()
                    phoneAuth()
                    
                }) {
                    Text("Sign Up")
                        .modifier(ButtonTextModifier())
                }
                .background(Color.orangeColor).cornerRadius(15)
                .frame(width: 200)
                .padding()
                
                Spacer()
                
            } //: VSTACK
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            .alert(item: $alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            
            
            
            
            if self.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
        } //: ZSTACK
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
