//
//  MockTestResource.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import Foundation

struct MockTestResource {
    
    let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber)
    
    func getMocktestList(completionHandler: @escaping(Result<MockTestResponse?, APIError>) -> Void) {
        
        
        
        guard let phoneNumber = phoneNumber else { return }
        
        if !K.byPassBaseURL.isEmpty {
            K.byPassBaseURL = ""
        }
        
        guard let url = URL.getMockTests(mobileNumber: phoneNumber) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: MockTestResponse.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
    func getSubjectTestList(completionHandler: @escaping(Result<SubjectTestResponse?, APIError>) -> Void) {
        
        if !K.byPassBaseURL.isEmpty {
            K.byPassBaseURL = ""
        }
        
        guard let url = URL.getSubjectTests() else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: SubjectTestResponse.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
    
    func getQBStep1(completionHandler: @escaping (Result<SubjectTestResponse?, APIError>) -> Void) {
        
        guard let url = URL.getQBStep1SubjectTests() else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: SubjectTestResponse.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getQBStep2(completionHandler: @escaping (Result<SubjectTestResponse?, APIError>) -> Void) {
        
        guard let url = URL.getQBStep2SubjectTests() else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: SubjectTestResponse.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
