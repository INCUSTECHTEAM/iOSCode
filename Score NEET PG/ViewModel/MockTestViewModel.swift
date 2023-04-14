//
//  MockTestViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 30/11/22.
//

import Foundation
import SwiftUI

/*
struct MockTestDataModel {
    var tabs: [TopTab] = [
        .init(title: "Grand Test"),
        .init(title: "PYQs QB"),
        .init(title: "QB Step 1")
    ]
    var selectedTab: Int = 0
    var mockTests: MockTestResponse = MockTestResponse()
    var subjectTests: SubjectTestResponse = SubjectTestResponse()
    var isLoading: Bool = false
    var refreshCounter = 0
}
*/
 
class MockTestViewModel: ObservableObject {
    
    @Published var tabs: [TopTab] = [
        .init(title: "Grand Test"),
        .init(title: "PYQs QB"),
        .init(title: "QB Step 1")
    ]
    @Published var selectedTab: Int = 0
    @Published var mockTests: MockTestResponse = MockTestResponse()
    @Published var subjectTests: SubjectTestResponse = SubjectTestResponse()
   // @Published var qbStepTests: SubjectTestResponse = SubjectTestResponse()
    @Published var isLoading: Bool = false
    @Published var refreshCounter = 0
    
    //@Published var mockTestDataModel: MockTestDataModel = MockTestDataModel()
    let mockTestResource: MockTestResource = MockTestResource()
    @Published var alertItem: AlertItem?
    
    func getUserDetails() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        NetworkManager.shared.getUser(mobileNumber: phoneNumber) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.isLoading = false
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
                    self.isLoading = false
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
            self.isLoading = true
            self.mockTests = []
        }
        
        mockTestResource.getMocktestList { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.refreshCounter += 1
                    print(self?.refreshCounter)
                    self?.isLoading = false
                    if let response {
                        if paymentStatus == false {
                            if let last = response.last {
                                self?.mockTests = response
                                self?.mockTests[0] = last
                                self?.mockTests.removeLast()
                            }
                        } else {
                            self?.mockTests = response
                        }
                        
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isLoading = false
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
            self.isLoading = true
            self.subjectTests = []
        }
        
        mockTestResource.getSubjectTestList { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let response {
                        self?.subjectTests = response
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isLoading = false
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
    
    func getQBStep1() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.subjectTests = []
        }
        
        mockTestResource.getQBStep1 { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let response {
                        self?.subjectTests = response
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isLoading = false
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
    
    
    
    
    func getQBStep2() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.subjectTests = []
        }
        
        mockTestResource.getQBStep2 { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let response {
                        self?.subjectTests = response
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isLoading = false
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
