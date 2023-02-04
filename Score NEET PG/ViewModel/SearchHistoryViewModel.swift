//
//  SearchHistoryViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 13/01/23.
//

import Foundation

class SearchHistoryViewModel: ObservableObject {
    
    @Published var historyList: SearchHistory = SearchHistory()
    
    func addParams(to url: URL, params: [String: String]) -> URL? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    func getHistory() {
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        guard let url = URL.getSearchHistory() else { return }
        let params = ["user": phoneNumber]
        guard let updatedURL = addParams(to: url, params: params) else { return }
        var urlRequest = URLRequest(url: updatedURL)
        urlRequest.httpMethod = "GET"
        
        
        HttpUtility.shared.postData(request: urlRequest, resultType: SearchHistory.self) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        self.historyList = response.filter({ $0.display == true })
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            guard let url = URL.getSearchHistory(id: historyList[index].id?.description) else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PATCH"
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            let deleteRequest = SearchHistoryElement(display: false)
            urlRequest.httpBody = try? JSONEncoder().encode(deleteRequest)
            
            HttpUtility.shared.postData(request: urlRequest, resultType: SearchHistoryElement.self) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.historyList.remove(at: index)
                    }
                case .failure(_):
                    break
                }
            }
            
        }
    }
    
    
    func deleteItems(_ item: SearchHistoryElement) {
            guard let url = URL.getSearchHistory(id: item.id?.description) else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PATCH"
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
            let deleteRequest = SearchHistoryElement(display: false)
            urlRequest.httpBody = try? JSONEncoder().encode(deleteRequest)
            
            HttpUtility.shared.postData(request: urlRequest, resultType: SearchHistoryElement.self) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.historyList.removeAll(where: { $0 == item })
                    }
                case .failure(_):
                    break
                }
            }
    }
    
    
}
