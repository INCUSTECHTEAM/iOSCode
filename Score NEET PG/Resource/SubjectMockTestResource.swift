//
//  SubjectMockTestResource.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import Foundation

struct SubjectMockTestResource {
    
    let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber)
    
    func getMocktests(gtId: String, completionHandler: @escaping(Result<MockTestResponse?, APIError>) -> Void) {
        guard let phoneNumber = phoneNumber else { return }
        
        var url = URL.getGtSubjectMock(userId: phoneNumber, gtId: gtId)
        
        guard let url = url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: MockTestResponse.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
                debugPrint(error)
            }
        }
    }
    
}
