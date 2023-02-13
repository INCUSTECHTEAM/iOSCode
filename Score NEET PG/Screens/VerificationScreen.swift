//
//  VerificationScreen.swift
//  Score MLE
//
//  Created by ios on 28/07/22.
//

import SwiftUI
import FirebaseAuth

struct VerificationScreen: View {
    
    // MARK: - PROPERTIES
    
    @EnvironmentObject var authentication: Authentication

    
    @State var otpCode: String = ""
    @State var isLoading = false
    @State private var action: Int? = 0
    @State var alertItem: AlertItem?
    //@State private var isUserDetailsUpdateViewPresented: Bool = false
    //@State private var isPresentedMainView: Bool = false
    
    var phoneNumber: String?
    
    // MARK: - FUNCTIONS
    
    private func resendOTP() {
        isLoading = true
        AuthManager.shared.resendOTP { result in
            switch result {
            case true:
                print("Resend Success")
                isLoading = false
            case false:
                print("Getting Error")
                isLoading = false
            }
        }
    }
    
    private func verifyOTP() {
        
        guard otpCode != "" else {
            return self.alertItem = AlertContext.otpMissing
        }
        
        isLoading = true
        AuthManager.shared.verifyCode(smsCode: otpCode) { result, data  in
            switch result {
            case true:
                isLoading = false
                checkUserDetails()
            case false:
                isLoading = false
                alertItem = AlertItem(title: Text("Error"), message: Text(data), dismissButton: .default(Text("Okay")))
            }
        }
    }
    
    
    private func checkUserDetails() {
        
        guard let phoneNumber = phoneNumber else {
            return
        }
        
        isLoading = true
        
//        NetworkManager.shared.getUserDetails(mobileNumber: phoneNumber) { result in
//            switch result {
//            case .success(let data):
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    if data.state {
//                        if data.userLst?.first?.name != "Deleted User" {
//                            updateUserDetails(userId: data.userLst?.first?.userID ?? "")
//                        } else {
//                            action = 1
//                        }
//
//                    } else {
//                        action = 1
//                    }
//                }
//            case .failure(let error):
//                self.isLoading = false
//
//                print("failure \(error.localizedDescription)")
//            }
//        }
        
        NetworkManager.shared.getUser(mobileNumber: phoneNumber) { result in
            isLoading = false
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if data.detail == nil {
                        //updateUserDetails(userId: data.username ?? "")
                        let userDetails = data
                        UserSession.userSessionInstance.setUserSession(userId: userDetails.id?.description ?? "",
                                                                       image: userDetails.photo ?? "",
                                                                       firstName: userDetails.firstName ?? "",
                                                                       lastName: userDetails.lastName ?? "",
                                                                       mobileNumber: phoneNumber,
                                                                       subscriptionPurchasedDate: userDetails.paymentExpiryDate)
                        
                        
                        //authentication.updateValidation(success: true)
                        action = 2
                    } else {
                        action = 1
                    }
                }
            case .failure(let error):
                print("failure \(error.localizedDescription)")
            }
        }
        
        
    }
    
    
//    private func updateUserDetails(userId: String) {
//        guard let phoneNumber = phoneNumber else {
//            return
//        }
//
////        let parameters: [String : Any] = [
////            "mobileNumber": phoneNumber,
////            "userId": userId,
////            "gcmId" : "123456"
////        ]
//
////        NetworkManager.shared.updateUserDetails(parameters: parameters) { result in
////            isLoading = false
////            switch result {
////            case .success(_):
////                authentication.updateValidation(success: true)
////            case .failure(let error):
////                print("failure \(error.localizedDescription)")
////            }
////        }
//
//        let parameters: [String : Any] = [
//            "username": phoneNumber
//        ]
//
//        NetworkManager.shared.updateUser(mobileNumber: phoneNumber, parameters: parameters) { result in
//            isLoading = false
//            switch result {
//            case .success(_):
//                authentication.updateValidation(success: true)
//            case .failure(let error):
//                print("failure \(error.localizedDescription)")
//            }
//        }
//    }
    
    // MARK: - BODY
    var body: some View {
            ZStack {
                VStack {
                    
                    // MARK: - NAVIGATIONS
                    
                    NavigationLink(destination: UserDetailsUpdateScreen(phoneNumber: phoneNumber), tag: 1, selection: $action) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: CourseSelectionScreen(isFromRegistration: true, navToHome: {
                        authentication.updateValidation(success: true)
                    }), tag: 2, selection: $action) {
                        EmptyView()
                    }
                    
                    
                    CustomNavigationView()
                        .padding(.horizontal)
                        .padding(.vertical , 10)
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 30) {
                        Text("Verify it's you!")
                            .foregroundColor(.orangeColor)
                            .font(.custom(K.Font.sfUITextBold, size: 20))
                            .multilineTextAlignment(.center)
                        
                        Text("Enter the verification code we just sent you on your phone number.")
                            .foregroundColor(.textColor)
                            .font(.custom(K.Font.sfUITextRegular, size: 15))
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            TextField("", text: $otpCode)
                                .placeholder(when: otpCode.isEmpty) {
                                    HStack(alignment: .center) {
                                        Spacer()
                                        Text("OTP").foregroundColor(.textColor)
                                        Spacer()
                                    }
                                    
                                }
                                .keyboardType(.decimalPad)
                                .frame(width: 150)
                                .foregroundColor(.textColor)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color.gray.opacity(0.2).cornerRadius(10))
                        } //: HSTACK
                        
                        HStack {
                            Text("If you didn't receive a code?")
                                .foregroundColor(.textColor)
                                .font(.custom(K.Font.sfUITextRegular, size: 15))
                            
                            Button(action: {
                                hideKeyboard()
                                resendOTP()
                            }) {
                                Text("Resend")
                                    .foregroundColor(.orangeColor)
                                    .font(.custom(K.Font.sfUITextRegular, size: 15))
                            }
                        } //: HSTACK
                        
                        //SIGN UP BUTTON
                        
                        Button(action: {
                            hideKeyboard()
                            verifyOTP()
                            
                        }) {
                            Text("Verify")
                                .modifier(ButtonTextModifier())
                        }
                        .background(Color.orangeColor).cornerRadius(15)
                        .frame(width: 180)
                        .padding()
                        
//#if  DEBUG
//                        Button(action: {
//                            hideKeyboard()
//                            isLoading = false
//                            checkUserDetails()
//                            
//                        }) {
//                            Text("Verify Without OTP")
//                                .modifier(ButtonTextModifier())
//                        }
//                        .background(Color.orangeColor).cornerRadius(15)
//                        .frame(width: 180)
//                        .padding()
//#endif
                       
                        
                    } //: VSTACK
                    
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
struct VerificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        VerificationScreen()
    }
}
