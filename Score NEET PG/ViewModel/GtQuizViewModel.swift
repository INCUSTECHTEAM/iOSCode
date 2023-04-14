//
//  GtQuizViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 02/12/22.
//

import Foundation
import SwiftUI


struct GtQuizDataModel {
    var gtTimerData = QuestionTimeDetailResponse()
    var questionsIdsList: QuestionIDSResponse = QuestionIDSResponse()
    var question: QuestionDetail = QuestionDetail()
    var allQuestionDetails: GetUserGtDetailResponse = GetUserGtDetailResponse()
    var questionUpdateRequest: QuestionUpdateRequest?
    var gtId: String = ""
    var rightAnswers: [QuestionIDSResponseElement] = [QuestionIDSResponseElement]()
    var wrongAnswers: [QuestionIDSResponseElement] = [QuestionIDSResponseElement]()
    var skipAnswer: [QuestionIDSResponseElement] = [QuestionIDSResponseElement]()
    var pendingQuestions: [QuestionIDSResponseElement] = [QuestionIDSResponseElement]()
    var isLoading = false
    var totalTime = 0
    var timeRemaining = 10
    var progress: CGFloat = 1
    var index = 0
    var item: Item? = nil
    var isQuizCompleted = false
    var IsOptionCorrectA = false
    var IsOptionCorrectB = false
    var IsOptionCorrectC = false
    var IsOptionCorrectD = false
    var IsOptionCorrectE = false
    
    var IsOptionCorrectASelected = false
    var IsOptionCorrectBSelected = false
    var IsOptionCorrectCSelected = false
    var IsOptionCorrectDSelected = false
    var IsOptionCorrectESelected = false
    
    var noDataAlertPresent = false
    var alertItem: AlertItem?
}



class GtQuizViewModel: ObservableObject {
    
    @Published var gtQuizDataModel : GtQuizDataModel = GtQuizDataModel()
    let gtQuizResource: GtQuizResource = GtQuizResource()
    
    var totalTime = K.byPassBaseURL.isEmpty ? 180 : 50
    
    //MARK: FUNCTIONS
    
    func progress() {
        self.gtQuizDataModel.progress = 1 - ((CGFloat(gtQuizDataModel.timeRemaining) / CGFloat(gtQuizDataModel.gtTimerData.first?.timeTook ?? 0)) / 100)
    }
    
    //Call API
    
    func getTimer(gtId: String) {
        gtQuizDataModel.isLoading = true
        gtQuizResource.getTimer(gtId: gtId) { [weak self] (result) in
            self?.gtQuizDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        self?.gtQuizDataModel.totalTime = (response.first?.timeTook ?? 0)
                        self?.gtQuizDataModel.gtTimerData = response
                        self?.gtQuizDataModel.timeRemaining = self!.totalTime - (response.first?.timeTook ?? 0)
                    }
                }
            case .failure(let error):
                self?.gtQuizDataModel.alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("Okay")))
            }
        }
    }
    
    func getQuestionsIds(gtId: String) {
        gtQuizDataModel.isLoading = true
        gtQuizResource.getQuestionsIdsList(gtId: gtId) { [weak self] (result) in
            self?.gtQuizDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        if response.isEmpty {
                            self?.gtQuizDataModel.noDataAlertPresent = true
                            return
                        }
                        self?.gtQuizDataModel.questionsIdsList = response
                        self?.gtQuizDataModel.pendingQuestions = response
                    }
                }
            case .failure(let error):
                self?.gtQuizDataModel.alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("Okay")))
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
    func getQuestion() {
        gtQuizDataModel.IsOptionCorrectA = false
        gtQuizDataModel.IsOptionCorrectB = false
        gtQuizDataModel.IsOptionCorrectC = false
        gtQuizDataModel.IsOptionCorrectD = false
        gtQuizDataModel.IsOptionCorrectE = false
        
        gtQuizDataModel.IsOptionCorrectASelected = false
        gtQuizDataModel.IsOptionCorrectBSelected = false
        gtQuizDataModel.IsOptionCorrectCSelected = false
        gtQuizDataModel.IsOptionCorrectDSelected = false
        gtQuizDataModel.IsOptionCorrectESelected = false
        
        gtQuizDataModel.isLoading = true
        gtQuizResource.getQuestion(questionId: gtQuizDataModel.questionsIdsList[gtQuizDataModel.index].id?.description ?? "") { [weak self] (result) in
            self?.gtQuizDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        self?.gtQuizDataModel.question = response
                    }
                }
            case .failure(let error):
                self?.gtQuizDataModel.alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("Okay")))
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
    func getAllQuestionDetails(id: String) {
        gtQuizDataModel.isLoading = true
        gtQuizResource.getQuestionDetail(questionId: id) { [weak self] (result) in
            self?.gtQuizDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        self?.gtQuizDataModel.allQuestionDetails = response
                    }
                }
            case .failure(let error):
                self?.gtQuizDataModel.alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("Okay")))
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
    func createGtRecord(request: QuestionUpdateRequest) {
        // gtQuizDataModel.isLoading = true
        gtQuizResource.createGtRecord(request: request) { [weak self] (result) in
            // self?.gtQuizDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response?.status == true {
                        //Action
                        self?.createDataForPauseQuiz(request: request)
                        if self?.gtQuizDataModel.questionsIdsList.count ?? 0 > self?.gtQuizDataModel.index ?? 0 {
                            self?.gtQuizDataModel.index += 1
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                                if self?.gtQuizDataModel.index ?? 0 < self?.gtQuizDataModel.questionsIdsList.count ?? 0 {
                                    self?.getQuestion()
                                } else {
                                    //Quiz Completed
                                    self?.updateLastSeen {
                                        self?.completeQuiz {
                                            self?.gtQuizDataModel.isQuizCompleted = true
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                }
            case .failure(let error):
                self?.gtQuizDataModel.alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("Okay")))
                DispatchQueue.main.async {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    func updateLastSeen(completion: @escaping () -> Void) {
        
        gtQuizDataModel.isLoading = true
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        let request = PauseQuestionRequest(wrongAnswers: gtQuizDataModel.wrongAnswers, rightAnswers: gtQuizDataModel.rightAnswers, skipAnswers: gtQuizDataModel.skipAnswer, questionsList: gtQuizDataModel.pendingQuestions, payload: PayloadData(), user: phoneNumber, gt: gtQuizDataModel.gtId)
        
        gtQuizResource.updateGtLastSeen(request: request) { [weak self] (result) in
            self?.gtQuizDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response?.status == true {
                        print("Update Success")
                        completion()
                    }
                }
            case .failure(let error):
                self?.gtQuizDataModel.alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("Okay")))
                DispatchQueue.main.async {
                    debugPrint(error)
                }
            }
        }
        
    }
    
    func updateTime(completion: @escaping () -> Void) {
        gtQuizDataModel.isLoading = true
        let request = QuizCompleteRequest(completed: false, time_took: (totalTime - gtQuizDataModel.timeRemaining))
        
        gtQuizResource.completeQuiz(gtId: gtQuizDataModel.gtId, request: request) { [weak self] (result) in
            self?.gtQuizDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                self?.gtQuizDataModel.alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("Okay")))
                DispatchQueue.main.async {
                    debugPrint(error)
                }
            }
        }
        
    }
    
    func completeQuiz(completion: @escaping () -> Void) {
        gtQuizDataModel.isLoading = true
        let request = QuizCompleteRequest(completed: true, time_took: (totalTime - gtQuizDataModel.timeRemaining))
        
        gtQuizResource.completeQuiz(gtId: gtQuizDataModel.gtId, request: request) { [weak self] (result) in
            self?.gtQuizDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("Completed Quiz")
                    completion()
                }
            case .failure(let error):
                self?.gtQuizDataModel.alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("Okay")))
                DispatchQueue.main.async {
                    debugPrint(error)
                }
            }
        }
        
    }
    
    func createDataForPauseQuiz(request: QuestionUpdateRequest) {
        
        gtQuizDataModel.pendingQuestions.removeAll(where: { $0.id == Int(request.question) })
        
        if request.score == "-1" {
            //Wrong Answer
            gtQuizDataModel.wrongAnswers.append(QuestionIDSResponseElement(id: Int(request.question)))
        } else if request.score == "4" {
            //Right Answer
            gtQuizDataModel.rightAnswers.append(QuestionIDSResponseElement(id: Int(request.question)))
        } else {
            //Skip Answer
            gtQuizDataModel.skipAnswer.append(QuestionIDSResponseElement(id: Int(request.question)))
        }
        
    }
    
    //TIMER FUNCTION
    
    
    func validateUserAnswer(gtId: String, option: String? = "") {
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        var score = 0
        
        if gtQuizDataModel.question.correctAnswer?.uppercased() == option?.uppercased() {
            score = 4
        } else if gtQuizDataModel.question.correctAnswer?.uppercased() != option?.uppercased() && !(option!.isEmpty) {
            score = -1
        }
        
        let request = QuestionUpdateRequest(user: phoneNumber,
                                            question: gtQuizDataModel.questionsIdsList[gtQuizDataModel.index].id?.description ?? "",
                                            score: score.description,
                                            choosenOption: option ?? "",
                                            gt: gtId)
        
        print(request)
        
        createGtRecord(request: request)
        
    }
    
    
    func deleteAudio(audioId: String, completion: @escaping () -> Void) {
        gtQuizDataModel.isLoading = true
        gtQuizResource.deleteAudio(request: DeleteAudioRequest(), audioId: audioId) { [weak self] (result) in
            self?.gtQuizDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("COmment Deleted")
                    completion()
                }
            case .failure(let error):
                self?.gtQuizDataModel.alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("Okay")))
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func uploadAudioRecording(audio: String, completion: @escaping () -> Void) {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        gtQuizDataModel.isLoading = true
        
        let request = RecordingUpdateRequest(fact: gtQuizDataModel.question.id ?? 0, audio: audio, user: phoneNumber)
        
        gtQuizResource.updateAudio(request: request) { [weak self] (result) in
            self?.gtQuizDataModel.isLoading = false
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("COmment Added")
                    completion()
                }
            case .failure(let error):
                self?.gtQuizDataModel.alertItem = AlertItem(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("Okay")))
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    //Check Correct Answer
    
    
    
    
}
