//
//  UserSessionKeyChain.swift
//  Score MLE
//
//  Created by ios on 29/07/22.
//

import Foundation

enum AppStorageKeys : String {
    case isLoggedIn
    case userID
}

struct UserDetailsKey {
    static let userId = "User_Id"
    static let firstname = "firstName"
    static let lastname = "lastName"
    static let image = "User_Image"
    static let mobileNumber = "User_Mobile_Number"
    static let subscription = "Subscription"
}


class UserSession {
    
    static let userSessionInstance = UserSession()
    
    
    
    //MARK: Save User Data
    func setUserSession(userId: String, image: String, firstName: String, lastName: String, mobileNumber:String, subscriptionPurchasedDate: String? = nil){
        
        UserDefaults.standard.set(userId, forKey: UserDetailsKey.userId)
        UserDefaults.standard.set(image, forKey: UserDetailsKey.image)
        UserDefaults.standard.set(firstName, forKey: UserDetailsKey.firstname)
        UserDefaults.standard.set(lastName, forKey: UserDetailsKey.lastname)
        UserDefaults.standard.set(mobileNumber, forKey: UserDetailsKey.mobileNumber)
        UserDefaults.standard.set(subscriptionPurchasedDate, forKey: UserDetailsKey.subscription)
        
    }
    
    func setSubscriptionExpiry(expiryDate: String) {
        if expiryDate != nil {
            UserDefaults.standard.set(expiryDate, forKey: UserDetailsKey.subscription)
        }
    }
    
    func isLoggedIn()-> Bool {
        if getUserSessions() == "" {
            return false
        } else {
            return true
        }
    }
    
    
    func getUserSessions() -> String{
        if let mobileNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) {
            return mobileNumber
        } else {
            return ""
        }
        
    }
    
    func subscriptionExpiration() {
        
        guard let purchasedDate = UserDefaults.standard.string(forKey: UserDetailsKey.subscription) else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:purchasedDate)!
        
        
        
    }
    
    
    func createPackageExpirationDate() -> String {
       
        let purchasedDate = Date()
        
        guard let expirationDate = Calendar.current.date(byAdding: .year, value: 1, to: purchasedDate) else {
            return ""
        }
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let myString = formatter.string(from: expirationDate) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyy-MM-dd"
        // again convert your date to string
        let myStringDate = formatter.string(from: yourDate!)

        print(myStringDate)
        
        
        return myStringDate
        
    }
    
    
    func getSubscriptionStatus() -> Bool {
        
        guard let purchasedDate = UserDefaults.standard.string(forKey: UserDetailsKey.subscription) else {
            return false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
       // dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from:purchasedDate) else {
            return false
        }
        
//        guard let expirationDate = Calendar.current.date(byAdding: .year, value: 1, to: date) else {
//            return false
//        }
        
        let seconds = (date.timeIntervalSince1970 - Date().timeIntervalSince1970)
        
        return seconds > 0 ? true : false
    }
    
    func removeUserSession() {
        UserDefaults.standard.removeObject(forKey: UserDetailsKey.userId)
        UserDefaults.standard.removeObject(forKey: UserDetailsKey.image)
        UserDefaults.standard.removeObject(forKey: UserDetailsKey.firstname)
        UserDefaults.standard.removeObject(forKey: UserDetailsKey.lastname)
        UserDefaults.standard.removeObject(forKey: UserDetailsKey.mobileNumber)
        UserDefaults.standard.removeObject(forKey: UserDetailsKey.subscription)
    }
}
