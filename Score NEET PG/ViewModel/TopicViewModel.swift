//
//  TopicViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 04/12/22.
//

import Foundation

struct TopicDataModel {
    var tabs: [TopTab] = [.init(title: "Attempted"),
                          .init(title: "Unattempted")]
    var selectedTabIndex = 0
    var topicAnalysis: TopicAnalysis = TopicAnalysis()
    var isLoading: Bool = false
}

class TopicViewModel: ObservableObject {
    
    @Published var topicDataModel: TopicDataModel = TopicDataModel()

    
    //Call Api
    
    func getTopicAnalysisData(subjectId: String) {
        topicDataModel.isLoading = true
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        var url = URL.topicWiseAnalysis(userId: phoneNumber, subjectId: subjectId) 
    
        
        guard let url = url else { return }
        
        var urlRequest = URLRequest(url: url)
        
        HttpUtility.shared.postData(request: urlRequest, resultType: TopicAnalysis.self) { [weak self] (result) in
            self?.topicDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        self?.topicDataModel.topicAnalysis = response
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    debugPrint(error)
                }
            }
        }
        
    }
    
}
