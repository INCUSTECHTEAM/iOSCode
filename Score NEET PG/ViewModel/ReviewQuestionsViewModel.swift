//
//  ReviewQuestionsViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import Foundation

struct ReviewQuestionsDataModel {
    var tabs: [TopTab] = [.init(title: "Correct Answer"),
                          .init(title: "Wrong Answer"),
                          .init(title: "Unanswered")
    ]
    var gtDetails = GetUserGtDetailResponse()
    var questionDetail = GetUserGtDetailElement()
    var selectedTab: Int = 0
    var correctIndex: Int = 0
    var wrongIndex: Int = 0
    var Unansweredindex: Int = 0
    var isLoading = false
    var item: Item? = nil
    var questionId = ""
    var isHideUnanswered = false
    var noDataAlertPresent = false
}

class ReviewQuestionsViewModel: ObservableObject {
    
    @Published var reviewQuestionDataModel: ReviewQuestionsDataModel = ReviewQuestionsDataModel()
    let reviewQuestionResource: ReviewQuestionResource = ReviewQuestionResource()
    
    //FILTERS
    var filterCorrectAnswers: GetUserGtDetailResponse {
        return reviewQuestionDataModel.gtDetails.filter({ $0.correctAnswer?.uppercased() == $0.userAnswer?.uppercased() })
    }
    
    var filterWrongAnswer: GetUserGtDetailResponse {
        return reviewQuestionDataModel.gtDetails.filter({ $0.score == -1 && $0.correctAnswer?.uppercased() != $0.userAnswer?.uppercased() })
    }
    
    var filterUnanswered: GetUserGtDetailResponse {
        return reviewQuestionDataModel.gtDetails.filter({ $0.score != -1 && $0.correctAnswer?.uppercased() != $0.userAnswer?.uppercased() })
    }
    
    
    var index: Int {
        switch reviewQuestionDataModel.tabs[reviewQuestionDataModel.selectedTab].title {
        case "Correct Answer":
            return reviewQuestionDataModel.correctIndex
        case "Wrong Answer":
            return reviewQuestionDataModel.wrongIndex
        case "Unanswered":
            return reviewQuestionDataModel.Unansweredindex
        default:
            return 0
        }
    }
    
    func reviewFilteredData() -> GetUserGtDetailResponse {
        switch reviewQuestionDataModel.tabs[reviewQuestionDataModel.selectedTab].title {
        case "Correct Answer":
            return filterCorrectAnswers
        case "Wrong Answer":
            return filterWrongAnswer
        case "Unanswered":
            return filterUnanswered
        default:
            return []
        }
    }
    
    
    
    func addTabs() {
        if filterCorrectAnswers.isEmpty {
            reviewQuestionDataModel.tabs.removeAll(where: { $0.title == "Correct Answer" })
        }
        if filterWrongAnswer.isEmpty {
            reviewQuestionDataModel.tabs.removeAll(where: { $0.title == "Wrong Answer" })
        }
        if filterUnanswered.isEmpty || reviewQuestionDataModel.isHideUnanswered {
            reviewQuestionDataModel.tabs.removeAll(where: { $0.title == "Unanswered" })
        }
    }
    
    func getUserGTDetail(id: String) {
        reviewQuestionDataModel.isLoading = true
        reviewQuestionResource.getUserGtDetail(questionId: id) { [weak self] (result) in
            self?.reviewQuestionDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        self?.reviewQuestionDataModel.gtDetails = response
                        
                        if self?.filterWrongAnswer.isEmpty == true && self?.filterCorrectAnswers.isEmpty == true {
                            if self?.reviewQuestionDataModel.isHideUnanswered == true {
                                self?.reviewQuestionDataModel.noDataAlertPresent = true
                                return
                            }
                        }
                        
                        self?.addTabs()
                        
                        if self?.reviewFilteredData().count ?? 0 > 0 {
                            self?.reviewQuestionDataModel.questionDetail = self?.reviewFilteredData()[self?.index ?? 0] ?? GetUserGtDetailElement()
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
    
    func deleteAudio(audioId: String, completion: @escaping () -> Void) {
        reviewQuestionDataModel.isLoading = true
        reviewQuestionResource.deleteAudio(request: DeleteAudioRequest(), audioId: audioId) { [weak self] (result) in
            self?.reviewQuestionDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("COmment Deleted")
                    completion()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func uploadAudioRecording(questionId: String, audio: String, completion: @escaping () -> Void) {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        reviewQuestionDataModel.isLoading = true
        
        let request = RecordingUpdateRequest(fact: Int(questionId) ?? 0, audio: audio, user: phoneNumber)
        
        reviewQuestionResource.updateAudio(request: request) { [weak self] (result) in
            self?.reviewQuestionDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("COmment Added")
                    completion()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func next() {
        switch reviewQuestionDataModel.tabs[reviewQuestionDataModel.selectedTab].title {
        case "Correct Answer":
            nextCorrect()
        case "Wrong Answer":
            nextWrong()
        case "Unanswered":
            nextUnanswered()
        default:
            break
        }
    }
    
    func prev() {
        switch reviewQuestionDataModel.tabs[reviewQuestionDataModel.selectedTab].title {
        case "Correct Answer":
            prevCorrect()
        case "Wrong Answer":
            prevWrong()
        case "Unanswered":
            prevUnanswered()
        default:
            break
        }
    }
    
    
    func nextCorrect() {
        if reviewQuestionDataModel.correctIndex + 1 <= filterCorrectAnswers.count {
            reviewQuestionDataModel.correctIndex += 1
        }
    }
    
    func nextWrong() {
        if reviewQuestionDataModel.wrongIndex + 1 <= filterWrongAnswer.count {
            reviewQuestionDataModel.wrongIndex += 1
        }
    }
    
    func nextUnanswered() {
        if reviewQuestionDataModel.Unansweredindex + 1 <= filterUnanswered.count {
            reviewQuestionDataModel.Unansweredindex += 1
        }
    }
    
    func prevCorrect() {
        if reviewQuestionDataModel.correctIndex <= filterCorrectAnswers.count {
            reviewQuestionDataModel.correctIndex -= 1
        }
    }
    
    func prevWrong() {
        if reviewQuestionDataModel.wrongIndex <= filterWrongAnswer.count {
            reviewQuestionDataModel.wrongIndex -= 1
        }
    }
    
    func prevUnanswered() {
        if reviewQuestionDataModel.Unansweredindex <= filterUnanswered.count {
            reviewQuestionDataModel.Unansweredindex -= 1
        }
    }
}
