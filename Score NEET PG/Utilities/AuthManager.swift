//
//  AuthManager.swift
//  Score MLE
//
//  Created by ios on 28/07/22.
//

import Foundation
import FirebaseAuth


class AuthManager {
    
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private var verificationId: String?
    private var phoneNumber: String?
    
    public func startAuth(phoneNumber: String, completion: @escaping (Bool, String?) -> Void) {
      
        self.phoneNumber = phoneNumber
        //auth.settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                return completion(false, error?.localizedDescription)
            }
            self?.verificationId = verificationId
            completion(true, verificationId)
        }
        
    }
    
    public func resendOTP(completion: @escaping (Bool) -> Void) {
        
        guard let phoneNumber = phoneNumber else {
            return
        }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                return completion(false)
            }
            self?.verificationId = verificationId
            completion(true)
        }
        
    }
    
    
    public func verifyCode(smsCode: String, completion: @escaping (Bool, String) -> Void) {
        
        guard let verificationId = verificationId else {
            return completion(false, "Invalid Verification Id, Please Start registration again.")
        }

        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: smsCode
        )
        
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                return completion(false, error?.localizedDescription ?? "Something went wrong")
            }
            guard let userID = self.auth.currentUser?.uid else { return }
            firebaseUserId = userID
            completion(true, "Registered Success")
        }
        
    }
    
    
    public func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try auth.signOut()
            UserSession.userSessionInstance.removeUserSession()
            completion(true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(false)
        }
        
    }
    
    
}
