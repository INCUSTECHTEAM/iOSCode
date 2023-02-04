//
//  LeaderboardResource.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import Foundation

struct LeaderboardResource {
    
    let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber)
    
    func getGtListData(gtId: String, completionHandler: @escaping(Result<GtlistResponse?, APIError>) -> Void) {
        guard let phoneNumber = phoneNumber else { return }
        
        guard let url = URL.getGtList(userId: phoneNumber, gtId: gtId) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: GtlistResponse.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
                debugPrint(error)
            }
        }
    }
    
    func getGtAnalysis(gtId: String, completionHandler: @escaping(Result<GtAnalysisResponse?, APIError>) -> Void) {
        guard let phoneNumber = phoneNumber else { return }
        
        guard let url = URL.getGtAnalysis(userId: phoneNumber, gtId: gtId) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: GtAnalysisResponse.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
                debugPrint(error)
            }
        }
    }
    
    func getGtLeaderboard(gtId: String, completionHandler: @escaping(Result<GtLeaderboard?, APIError>) -> Void) {
        guard let phoneNumber = phoneNumber else { return }
        
        guard let url = URL.getGtLeaderboard(gtId: gtId) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: GtLeaderboard.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
                debugPrint(error)
            }
        }
    }
    
    func getStAnalysis(stId: String, completionHandler: @escaping(Result<GtAnalysisResponse?, APIError>) -> Void) {
        guard let phoneNumber = phoneNumber else { return }
        
        guard let url = URL.getStAnalysis(userId: phoneNumber, stId: stId) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: GtAnalysisResponse.self) { result in
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
