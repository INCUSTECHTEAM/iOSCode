//
//  MockTestViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 30/11/22.
//

import Foundation
import SwiftUI

struct MockTestDataModel {
    var tabs: [TopTab] = [.init(title: "Grand Test"),
                                 .init(title: "Subject Test")]
    var selectedTab: Int = 0
    var mockTests: MockTestResponse = MockTestResponse()
    var subjectTests: SubjectTestResponse = SubjectTestResponse()
    var isLoading: Bool = false
}

class MockTestViewModel: ObservableObject {
    
   
    
    @Published var mockTestDataModel: MockTestDataModel = MockTestDataModel()
    let mockTestResource: MockTestResource = MockTestResource()
    
    
    func getUserDetails() {
        mockTestDataModel.isLoading = true
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        NetworkManager.shared.getUser(mobileNumber: phoneNumber) { result in
            self.mockTestDataModel.isLoading = false
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
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
                    print("failure \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    
    func getMockTests() {
        mockTestDataModel.isLoading = true
        mockTestResource.getMocktestList { [weak self] (result) in
            self?.mockTestDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
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
                    print(error)
                }
            }
        }
    }
    
    func getSubjectTests() {
        mockTestDataModel.isLoading = true
        mockTestResource.getSubjectTestList { [weak self] (result) in
            self?.mockTestDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        self?.mockTestDataModel.subjectTests = response
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
}
