//
//  Authentication.swift
//  Score MLE
//
//  Created by Manoj kumar on 06/08/22.
//

import SwiftUI

class Authentication: ObservableObject {
    @Published var isValidated = false
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
        case invalidCredentials, invalidURL, unableToComplete, invalidResponse, invalidData
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return NSLocalizedString("Phone number is incorrect. Please try again", comment: "")
            case .invalidURL:
                return NSLocalizedString("Server Error. Please try again", comment: "")
            case .unableToComplete:
                return NSLocalizedString("Server Error is incorrect. Please try again", comment: "")
            case .invalidResponse:
                return NSLocalizedString("Server Error is incorrect. Please try again", comment: "")
            case .invalidData:
                return NSLocalizedString("Server Error is incorrect. Please try again", comment: "")
            }
        }
    }
    
    func updateValidation(success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
}
