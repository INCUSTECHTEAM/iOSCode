//
//  ReviewQuestionResource.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 02/12/22.
//

import Foundation

struct ReviewQuestionResource {
    
    let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber)
    
 
    func getUserGtDetail(questionId: String, completionHandler: @escaping(Result<GetUserGtDetailResponse?, APIError>) -> Void) {
        guard let phoneNumber else { return }
        guard let url = URL.getUserGtDetail(userId: phoneNumber, questionId: questionId) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: GetUserGtDetailResponse.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
                debugPrint(error)
            }
        }
    }
    
    
    func deleteAudio(request: DeleteAudioRequest, audioId: String, completionHandler: @escaping(Result<AudioResponse?, APIError>) -> Void) {
        guard let url = URL.grandTestAudio(audioId: audioId) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        
        HttpUtility.shared.postData(request: urlRequest, resultType: AudioResponse.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                debugPrint(error)
                completionHandler(.failure(error))
            }
        }
    }
    
    func updateAudio(request: RecordingUpdateRequest, completionHandler: @escaping(Result<AudioResponse?, APIError>) -> Void) {
        guard let url = URL.grandtestAudioCreate() else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        
        HttpUtility.shared.postData(request: urlRequest, resultType: AudioResponse.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                debugPrint(error)
                completionHandler(.failure(error))
            }
        }
    }
    
}
