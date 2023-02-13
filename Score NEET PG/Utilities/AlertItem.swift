//
//  AlertItem.swift
//  Score MLE
//
//  Created by ios on 29/07/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text
    var dismissButton: Alert.Button?
}

enum AlertContext {
    
    //MARK: - Network Errors
    static let invalidURL       = AlertItem(title: Text("Server Error"),
                                            message: Text("There is an error trying to reach the server. If this persists, please contact support."),
                                            dismissButton: .default(Text("Ok")))
    
    static let unableToComplete = AlertItem(title: Text("Server Error"),
                                            message: Text("Unable to complete your request at this time. Please check your internet connection."),
                                            dismissButton: .default(Text("Ok")))
    
    static let invalidResponse  = AlertItem(title: Text("Server Error"),
                                            message: Text("Invalid response from the server. Please try again or contact support."),
                                            dismissButton: .default(Text("Ok")))
    
    static let invalidData      = AlertItem(title: Text("Server Error"),
                                            message: Text("The data received from the server was invalid. Please try again or contact support."),
                                            dismissButton: .default(Text("Ok")))
    
    static let decodeData       = AlertItem(title: Text("Error"),
                                            message: Text("An error occurred while trying to decode the API response. Please try again or contact support."),
                                            dismissButton: .default(Text("Ok")))
    
    
    static let invalidPhoneNumber = AlertItem(title: Text(""), message: Text("Please Enter Phone Number"), dismissButton: .default(Text("Okay")))
    
    static let termsNotAccepted = AlertItem(title: Text(""), message: Text("Please Accept the Term & Conditions"), dismissButton: .default(Text("Okay")))
    
    static let otpMissing = AlertItem(title: Text(""), message: Text("Please enter correct OTP"), dismissButton: .default(Text("Okay")))
    
    static let firstNameMissing = AlertItem(title: Text(""), message: Text("Please enter first name"), dismissButton: .default(Text("Okay")))
    
    static let lastNameMissing = AlertItem(title: Text(""), message: Text("Please enter last name"), dismissButton: .default(Text("Okay")))
}

