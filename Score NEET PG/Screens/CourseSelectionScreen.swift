//
//  CourseSelectionScreen.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 09/02/23.
//

import SwiftUI

struct CourseSelectionScreen: View {
    
    //MARK: PROPERTY
    @Environment(\.dismiss) private var dismiss
    
    var isFromRegistration: Bool = false
    var navToHome: () -> Void?
    
   let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber)
    
    //MARK: - Functions
    
    func updatePaymentStatus() {
        guard let phoneNumber = phoneNumber else { return }
        
        NetworkManager.shared.getUser(mobileNumber: phoneNumber) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if data.detail == nil {
                        UserSession.userSessionInstance.setSubscriptionExpiry(expiryDate: data.paymentExpiryDate ?? "")
                        if let staff = data.is_staff {
                            withAnimation {
                                isStaff = staff
                            }
                        }
                        if data.paid == true {
                            paymentStatus = true
                        } else {
                            if UserSession.userSessionInstance.getSubscriptionStatus() {
                                paymentStatus = true
                                //self.isAvailableToSearch = true
                            } else {
                                paymentStatus = false
                                //self.isAvailableToSearch = false
                            }
                        }
                        if isFromRegistration {
                            navToHome()
                        } else {
                            dismiss()
                        }
                    } else {
                        
                        //User Not Available
                        getFetchUserInfoReleventFromReleventServer()
                        
                    }
                    
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("failure \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    //MARK: get User Details from another vice versa database
    
    func getFetchUserInfoReleventFromReleventServer() {
        
        var url: URL?
        
        guard let phoneNumber = phoneNumber else { return }
        
        let selectedCouse = CourseEnvironment.shared.checkSelectedCourse()
        
        if selectedCouse == Courses.NEETPG.rawValue {
            url = URL(string: "https://chatbot-backend.mbbscare.in/progress/user/\(phoneNumber)/")
        } else if selectedCouse == Courses.Nursing.rawValue {
            url = URL(string: "https://nurse-coach.mbbscare.in/progress/user/\(phoneNumber)/")
        } else if selectedCouse == Courses.USMLESTEP1.rawValue {
            url = URL(string: "https://usmle-backend.mbbscare.in/progress/user/\(phoneNumber)/")
        } else {
            url = URL(string: "https://chatbot-backend.mbbscare.in/progress/user/\(phoneNumber)/")
        }
        
        guard let url = url else { return }
        
        NetworkManager.shared.getUserFromAnotherServer(url: url, mobileNumber: phoneNumber) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if data.detail == nil {
                        updateMissingUserInfo(data)
                    } else {
                        //User Not Found in both server
                        UserSession.userSessionInstance.removeUserSession()
                    }
                }
            case .failure(_):
                break
            }
        }
        
    }
    
    
    private func updateMissingUserInfo(_ user: User) {
        
        guard let phoneNumber = phoneNumber else {
            return
        }
        
        let parameters: [String : Any] = [
            "username": phoneNumber,
            "first_name": user.firstName ?? "",
            "last_name": user.lastName ?? "",
            "photo": user.photo ?? ""
        ]
        
        NetworkManager.shared.updateUser(mobileNumber: phoneNumber, parameters: parameters) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    updatePaymentStatus()
                }
                
            case .failure(_):
                print("Error")
            }
        }
        
    }
    
    //MARK: - BODY
    var body: some View {
        VStack(alignment: .center) {
            Image("ScoreLogo")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 40)
            
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 10) {
                    Button {
                        CourseEnvironment.shared.set(course: .NEETPG)
                        updatePaymentStatus()
                    } label: {
                        VStack {
                            Image("doctor")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .foregroundColor(.orangeColor)
                                .padding(.vertical, 20)
                                .padding(.horizontal, 20)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 1)
                                        
                                }
                                
                            
                            Text("NEETPG")
                        }
                    }
                    .padding()
                    
                    
                    Button {
                        CourseEnvironment.shared.set(course: .Nursing)
                        updatePaymentStatus()
                    } label: {
                        VStack {
                            Image("nurse")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .foregroundColor(.orangeColor)
                                .padding(.vertical, 20)
                                .padding(.horizontal, 20)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 1)
                                        
                                }
                                
                            
                            Text("Nursing")
                        }
                    }
                    .padding()
                    
                }
                .padding(.horizontal)
                
                HStack(alignment: .center) {
                    Button {
                        CourseEnvironment.shared.set(course: .USMLESTEP1)
                        updatePaymentStatus()
                    } label: {
                        VStack {
                            Image("statue-of-liberty")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .foregroundColor(.orangeColor)
                                .tint(.orangeColor)
                                .padding(.vertical, 20)
                                .padding(.horizontal, 20)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 1)
                                        
                                }
                                
                            
                            Text("USMLE STEP 1")
                        }
                    }
                    .padding()
                    
                }
                //.padding()
                
                
                
            }
            
            Spacer()
        }
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
}

struct CourseSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        CourseSelectionScreen(navToHome: {})
    }
}
