//
//  SettingScreen.swift
//  Score MLE
//
//  Created by ios on 30/07/22.
//

import SwiftUI
import Kingfisher

struct SettingScreen: View {
    // MARK: - PROPERTIES
    
    @EnvironmentObject var authentication: Authentication
    
    @State private var isOnboardViewPresented = false
    @State private var expirationDate = ""
    @State private var isPresentedUpdateUserDetails = false
    @State private var showingAlert = false
    @State private var deletedAccountShowingAlert = false
    @State private var isLoading = false
    
    @State var firstname = UserDefaults.standard.string(forKey: UserDetailsKey.firstname)
    @State var lastname = UserDefaults.standard.string(forKey: UserDetailsKey.lastname)
    @State var mobileNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber)
    @State var image = UserDefaults.standard.string(forKey: UserDetailsKey.image)
    
    // MARK: - FUNCTIONS
    
    
    private func updateDetails() {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else {
            return
        }
        
        isLoading = true
        
//        let parameters: [String : Any] = [
//            "mobileNumber": phoneNumber,
//            "name": "Deleted User",
//            "imageURL": "Deleted User",
//            "gcmId" : "123456"
//        ]
//
//        NetworkManager.shared.updateUserDetails(parameters: parameters) { result in
//            isLoading = false
//            switch result {
//            case .success(_):
//                print("User Deleted Successfully")
//
//                deletedAccountShowingAlert.toggle()
//
//            case .failure(_):
//                break
//            }
//        }
        
        
        NetworkManager.shared.deleteUser(mobileNumber: phoneNumber) { result in
            isLoading = false
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    deletedAccountShowingAlert.toggle()
                }
            case .failure(_):
                break
            }
        }
        
    }
    
    private func deleteAccountData() {
        NetworkManager.shared.deleteAllData { result in
            switch result {
            case .success(_):
                print("Account Data Deleted Successfully")
            case .failure(_):
                print("Getting")
            }
        }
    }
    
    

    
    
    // MARK: - BODY
    var body: some View {
       // NavigationView {
            
            ZStack {
                
                VStack(spacing: 20) {
                    HStack {
                        
                        Text("Setting")
                            .font(.custom(K.Font.sfUITextBold, size: 32))
                            .foregroundColor(.textColor)
                            .padding(.all, 10)
                        
                        Spacer()
                    }
                    
                    GroupBox() {
                        VStack {
                            HStack {
                                KFImage(URL(string: image ?? ""))
                                    .placeholder({
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color.orangeColor)
                                        
                                        
                                    })
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(30)
                                    .padding(.trailing)
                                    .offset(y: -4)
                                
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text((firstname ?? "") + " " + (lastname ?? ""))
                                        .font(.custom(K.Font.sfUITextRegular, size: 18))
                                        .foregroundColor(.textColor)
                                    Text(mobileNumber ?? "")
                                        .font(.custom(K.Font.sfUITextRegular, size: 16))
                                        .foregroundColor(.textColor)
                                } //: VSTACK
                                .offset(y: -4)
                                
                                Spacer()
                            } //: HSTACK
                            
                            if !expirationDate.isEmpty {
                                HStack {
                                    Text("Subscription Expires at: \(expirationDate)")
                                        .foregroundColor(.textColor)
                                        .font(.custom(K.Font.sfUITextRegular, size: 14))
                                    
                                    Spacer()
                                }
                                HStack {
                                    Text("Manage subscription from App Store")
                                        .foregroundColor(.textColor.opacity(0.7))
                                        .font(.custom(K.Font.sfUITextRegular, size: 12))
                                    Spacer()
                                }
                            }
                            
                            
                            
                        }
                        .frame(height: expirationDate.isEmpty ? 40 : 70)
                    }//:BOX
                    .groupBoxStyle(ColoredGroupBox())
                    .onTapGesture {
                        withAnimation {
                            isPresentedUpdateUserDetails.toggle()
                        }
                    }
                    .fullScreenCover(isPresented: $isPresentedUpdateUserDetails) {
                        EditProfileScreen()
                            .onDisappear {
                                firstname = UserDefaults.standard.string(forKey: UserDetailsKey.firstname)
                                lastname = UserDefaults.standard.string(forKey: UserDetailsKey.lastname)
                                image = UserDefaults.standard.string(forKey: UserDetailsKey.image)
                            }
                    }
                    
                    
                    
                    GroupBox() {
                        SettingRowView(linkLabel: "Contact Us", linkDestination: "wa.me/+919000868356")
                            .frame(height: 40)
                        
                        Divider()
                            .foregroundColor(.white)
                            .padding(.vertical, 0)
                        
                        
                        SettingRowView(linkLabel: "Terms of Service", linkDestination: "playscore.live/termsandconditionsofuse")
                            .frame(height: 40)
                        
                        Divider()
                            .foregroundColor(.white)
                            .padding(.vertical, 0)
                        
                        
                        SettingRowView(linkLabel: "Privacy Policy", linkDestination: "playscore.live/privacypolicy")
                            .frame(height: 40)
                        
                        
                        Divider()
                            .foregroundColor(.white)
                            .padding(.vertical, 0)
                        
                        
                        SettingRowView(linkLabel: "Delete Account", linkDestination: nil)
                            .frame(height: 40)
                            .onTapGesture {
                                print("Deleted Account")
                                showingAlert = true
                            }
                        
                        
                    }//:BOX
                    .groupBoxStyle(ColoredGroupBox())
                    
                    
                    Button(action: {
                        
                        AuthManager.shared.signOut { result in
                            switch result {
                            case true:
                                authentication.updateValidation(success: false)
                            case false:
                                print("Error in logut, please connect with internet")
                            }
                        }
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("Logout")
                                .font(.custom(K.Font.sfUITextRegular, size: 18))
                                .foregroundColor(.textColor)
                                .padding(.vertical, 10)
                            Spacer()
                        }
                    }
                    .modifier(ButtonRectangleModifier())
                    .fullScreenCover(isPresented: $isOnboardViewPresented, content: OnboardScreen.init)
                    
                    Spacer()
                }
                .padding()
//                .navigationTitle("Settings")
//                .navigationBarTitleDisplayMode(.large)
                .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
                .alert("Delete Account", isPresented: $showingAlert) {
                    Button(role: .cancel, action: {
                        showingAlert = false
                    }) {
                        Text("Cancel")
                    }
                    Button(action: {
                        
                        updateDetails()
                        
                    }) {
                        Text("Delete")
                    }
                } message: {
                    Text("Are you sure you want to delete your account? This will permanent erase your account.")
                }
                .alert("Success", isPresented: $deletedAccountShowingAlert) {
                    Button(role: .cancel, action: {
                        
                        AuthManager.shared.signOut { result in
                            switch result {
                            case true:
                                deleteAccountData()
                                authentication.updateValidation(success: false)
                            case false:
                                print("Error in logut, please connect with internet")
                            }
                        }
                        
                    }) {
                        Text("Okay")
                    }
                } message: {
                    Text("Account Deleted Succesfully.")
                }
                
            }
            .navigationBarTitleDisplayMode(.large)
            
            
            if self.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
            
        //} //: NAVIGATION
    }
}

struct SettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingScreen()
    }
}


