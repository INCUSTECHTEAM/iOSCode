//
//  GtQuizResource.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 02/12/22.
//

import Foundation

struct GtQuizResource {
    
    let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber)
    
    func getTimer(gtId: String, completionHandler: @escaping(Result<QuestionTimeDetailResponse?, APIError>) -> Void) {
        guard let phoneNumber else { return }
        guard let url = URL.getGtTimerDetail(userId: phoneNumber, gtId: gtId) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: QuestionTimeDetailResponse.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
                debugPrint(error)
            }
        }
        
    }
    
    func getQuestionsIdsList(gtId: String, completionHandler: @escaping(Result<QuestionIDSResponse?, APIError>) -> Void) {
        guard let phoneNumber else { return }
        guard let url = URL.getQuestionsList(userId: phoneNumber, gtId: gtId) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: QuestionIDSResponse.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
                debugPrint(error)
            }
        }
        
    }
    
    func getQuestion(questionId: String, completionHandler: @escaping(Result<QuestionDetail?, APIError>) -> Void) {
        guard let url = URL.getQuestion(questionId: questionId) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: QuestionDetail.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
                debugPrint(error)
            }
        }
        
    }
    
    func getQuestionDetail(questionId: String, completionHandler: @escaping(Result<GetUserGtDetailResponse?, APIError>) -> Void) {
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
    
    func createGtRecord(request: QuestionUpdateRequest, completionHandler: @escaping(Result<CreateGtRecord? ,APIError>) -> Void) {
        guard let url = URL.createGtRecord() else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        
        HttpUtility.shared.postData(request: urlRequest, resultType: CreateGtRecord.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
                debugPrint(error)
            }
        }
    }
    
    func completeQuiz(gtId: String, request: QuizCompleteRequest, completionHandler: @escaping(Result<QuestionTimeDetailResponseElement?, APIError>) -> Void) {
        guard let phoneNumber else { return }
        guard let url = URL.getGtTimerDetail(userId: phoneNumber, gtId: gtId) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        
        HttpUtility.shared.postData(request: urlRequest, resultType: QuestionTimeDetailResponseElement.self) { result in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
                debugPrint(error)
            }
        }
    }
    
    func updateGtLastSeen(request: PauseQuestionRequest, completionHandler: @escaping(Result<CreateGtRecord?, APIError>) -> Void) {
        guard let url = URL.updateQuestionLastSeen() else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        HttpUtility.shared.postData(request: urlRequest, resultType: CreateGtRecord.self) { result in
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
