//
//  AudioMantraListViewModel.swift
//  Score NEET PG
//
//  Created by Rahul on 13/04/23.
//

import Foundation

class AudioMantraListViewModel: ObservableObject {
    
    @Published var list = [AudioMantraListData]()
    @Published var totalSlideCount = "0"
    @Published var readCount = "0"
    @Published var bookmarkedCount = "0"
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber)
    
    
    func getAudioMantraList() {
        
        guard let phoneNumber = phoneNumber else { return }
        
        guard let url = URL.audioMantraList(userId: phoneNumber) else { return }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: AudioMantraListResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let data = response?.data, let stats = response?.stats {
                        self?.list = data
                        self?.totalSlideCount = stats.totalCount?.description ?? "0"
                        self?.bookmarkedCount = stats.totalBookmarked?.description ?? "0"
                        self?.readCount = stats.totalToBeRead?.description ?? "0"
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
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
