//
//  EditProfileScreen.swift
//  Score MLE
//
//  Created by Manoj kumar on 03/08/22.
//

import SwiftUI
import Kingfisher

struct EditProfileScreen: View {
    // MARK: - PROPERTIES
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var isLoading: Bool = false
    
    @State private var isShowingPhotoPicker: Bool = false
    @State var avatarImage = UIImage(systemName: "person.circle.fill")!.withTintColor(.orange)
    @State var alertItem: AlertItem?
    @State private var avatarURL: String = ""
    
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - FUNCTIONS
    
    private func downloadImage(url: String){
        NetworkManager.shared.downloadImage(from: url) { image in
            DispatchQueue.main.async {
                if let image = image {
                    avatarImage = image
                }
            }
        }
    }
    
    
    private func updateDetails() {
        
        guard firstName != "" else {
            return self.alertItem = AlertContext.firstNameMissing
        }
        
        guard avatarURL != "" else {
            return self.alertItem = AlertItem(title: Text(""), message: Text("Please Select Profile Image"), dismissButton: .default(Text("Okay")))
        }
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else {
            return
        }
        
        isLoading = true
        
//        let parameters: [String : Any] = [
//            "mobileNumber": phoneNumber,
//            "name": "\(firstName)",
//            "imageURL": avatarURL,
//            "gcmId" : "123456"
//        ]
        
//        NetworkManager.shared.updateUserDetails(parameters: parameters) { result in
//            isLoading = false
//            switch result {
//            case .success(_):
//                self.presentationMode.wrappedValue.dismiss()
//
//            case .failure(_):
//                break
//            }
//        }
        
        let parameters: [String : Any] = [
            "username": phoneNumber,
            "first_name": firstName,
            "last_name": lastName,
            "photo": avatarURL
        ]
        
        
        NetworkManager.shared.updateUser(mobileNumber: phoneNumber, parameters: parameters, apiType: "PATCH") { result in
            isLoading = false
            switch result {
            case .success(_):
                self.presentationMode.wrappedValue.dismiss()
            case .failure(_):
                break
            }
        }
        
    }
    
    private func uploadAvatar() {
        isLoading = true
        AWSS3Manager.shared.uploadImage(image: avatarImage) { progress in
            print(progress)
            isLoading = false
        } completion: { response, error in
            if let _ =  error {
                return
            }
            
            guard let response = response as? String else {
                isLoading = false
                return
            }
            isLoading = false
            avatarURL = response
            updateDetails()
            print(response)
        }
        
    }
    
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 30) {
                
                CustomNavigationView(name: "Edit Profile")
                
                Spacer()
                
                //IMAGE UPDATE BUTTON
                Button(action: {
                    isShowingPhotoPicker.toggle()
                }) {
                    Image(uiImage: avatarImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orangeColor)
                        .tint(.orangeColor)
                        .cornerRadius(40)
                        .padding(5)
                        .overlay(
                            Circle()
                                .stroke(Color.textColor, lineWidth: 1)
                        )
                        .overlay {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .font(.system(size: 15, weight: .bold, design: .default))
                                .foregroundColor(.textColor)
                                .offset(x: 30, y: 30)
                        }
                    
                }
                
                
                //TEXTFIELD FIRST NAME
                
                HStack {
                    
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.orangeColor)
                    
                    
                    
                    TextField("", text: $firstName)
                        .placeholder(when: firstName.isEmpty) {
                            Text("First Name").foregroundColor(.textColor)
                        }
                        .font(.custom(K.Font.sfUITextRegular, size: 16))
                        .foregroundColor(.textColor)
                        .textContentType(.name)
                    
                } //: HSTACK
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.clear)
                    //.stroke(Color.backgroundColor.opacity(0.7), lineWidth: 1)
                )
                .background(Color.gray.opacity(0.2).cornerRadius(20))
                
                
                //TEXTFIELD Last NAME
                
                HStack {
                    
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.orangeColor)
                    
                    
                    
                    TextField("", text: $lastName)
                        .placeholder(when: lastName.isEmpty) {
                            Text("Last Name").foregroundColor(.textColor)
                        }
                        .font(.custom(K.Font.sfUITextRegular, size: 16))
                        .foregroundColor(.textColor)
                        .textContentType(.name)
                        
                    
                } //: HSTACK
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.clear)
                    //.stroke(Color.backgroundColor.opacity(0.7), lineWidth: 1)
                )
                .background(Color.gray.opacity(0.2).cornerRadius(20))
                .hidden()
                
                
                Button(action: {
                    
                    hideKeyboard()
                    
                    guard firstName != "" else {
                        return self.alertItem = AlertContext.firstNameMissing
                    }
                    
//                    guard lastName != "" else {
//                        return self.alertItem = AlertContext.lastNameMissing
//                    }
                    
                    uploadAvatar()
                    
                }) {
                    Text("Update")
                        .modifier(ButtonTextModifier())
                }
                .background(Color.orangeColor).cornerRadius(15)
                .frame(width: 180)
                .padding()
                
                
                Spacer()
            } //: VSTACK
            .padding()
            .alert(item: $alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            .sheet(isPresented: $isShowingPhotoPicker) {
                PhotoPicker(avatarImage: $avatarImage)
            }
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            
            
            if self.isLoading {
                GeometryReader { proxy in
                    Loader()
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
            
        } //: ZSTACK
        .onAppear {
            
            if let image = UserDefaults.standard.string(forKey: UserDetailsKey.image) {
                downloadImage(url: image)
            }
            
            if let firstname = UserDefaults.standard.string(forKey: UserDetailsKey.firstname) {
                self.firstName = firstname
            }
            
//            if let lastname = UserDefaults.standard.string(forKey: UserDetailsKey.lastname) {
//                self.lastName = lastname
//            }
        }
        
    }
}

struct EditProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileScreen()
    }
}
