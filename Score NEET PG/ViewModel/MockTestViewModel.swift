//
//  MockTestViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 30/11/22.
//

import Foundation
import SwiftUI

struct MockTestDataModel {
    var tabs: [TopTab] = [
        .init(title: "Grand Test"),
        .init(title: "Subject Test"),
    ]
    var selectedTab: Int = 0
    var mockTests: MockTestResponse = MockTestResponse()
    var subjectTests: SubjectTestResponse = SubjectTestResponse()
    var isLoading: Bool = false
    var refreshCounter = 0
}

class MockTestViewModel: ObservableObject {
    
   
    
    @Published var mockTestDataModel: MockTestDataModel = MockTestDataModel()
    let mockTestResource: MockTestResource = MockTestResource()
    @Published var alertItem: AlertItem?
    
    func getUserDetails() {
        DispatchQueue.main.async {
            self.mockTestDataModel.isLoading = true
        }
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        NetworkManager.shared.getUser(mobileNumber: phoneNumber) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.mockTestDataModel.isLoading = false
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
                        } else {
                            paymentStatus = false
                        }
                    }
                    self.getMockTests()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.mockTestDataModel.isLoading = false
                    if error == .invalidResponse {
                        self.alertItem = AlertContext.invalidResponse
                    } else if error == .invalidData {
                        self.alertItem = AlertContext.invalidData
                    } else if error == .unableToComplete {
                        self.alertItem = AlertContext.unableToComplete
                    } else if error == .invalidURL {
                        self.alertItem = AlertContext.invalidURL
                    } else {
                        self.alertItem = AlertContext.decodeData
                    }
                }
            }
        }
        
    }
    
    
    func getMockTests() {
        DispatchQueue.main.async {
            self.mockTestDataModel.isLoading = true
            self.mockTestDataModel.mockTests = []
        }
        
        mockTestResource.getMocktestList { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.mockTestDataModel.refreshCounter += 1
                    print(self?.mockTestDataModel.refreshCounter)
                    self?.mockTestDataModel.isLoading = false
                    if let response {
                        if paymentStatus == false {
                            if let last = response.last {
                                self?.mockTestDataModel.mockTests = response
                                self?.mockTestDataModel.mockTests[0] = last
                                self?.mockTestDataModel.mockTests.removeLast()
                            }
                        } else {
                            self?.mockTestDataModel.mockTests = response
                        }
                        
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.mockTestDataModel.isLoading = false
                    if error == .invalidResponse {
                        self?.alertItem = AlertContext.invalidResponse
                    } else if error == .invalidData {
                        self?.alertItem = AlertContext.invalidData
                    } else if error == .unableToComplete {
                        self?.alertItem = AlertContext.unableToComplete
                    } else if error == .invalidURL {
                        self?.alertItem = AlertContext.invalidURL
                    } else {
                        self?.alertItem = AlertContext.decodeData
                    }
                }
            }
        }
    }
    
    func getSubjectTests() {
        DispatchQueue.main.async {
            self.mockTestDataModel.isLoading = true
            self.mockTestDataModel.subjectTests = []
        }
        
        mockTestResource.getSubjectTestList { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.mockTestDataModel.isLoading = false
                    if let response {
                        self?.mockTestDataModel.subjectTests = response
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.mockTestDataModel.isLoading = false
                    if error == .invalidResponse {
                        self?.alertItem = AlertContext.invalidResponse
                    } else if error == .invalidData {
                        self?.alertItem = AlertContext.invalidData
                    } else if error == .unableToComplete {
                        self?.alertItem = AlertContext.unableToComplete
                    } else if error == .invalidURL {
                        self?.alertItem = AlertContext.invalidURL
                    } else {
                        self?.alertItem = AlertContext.decodeData
                    }
                }
            }
        }
    }
    
}
