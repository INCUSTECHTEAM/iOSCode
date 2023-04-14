//
//  AudioMantraDetailsViewModel.swift
//  Score NEET PG
//
//  Created by Rahul on 14/04/23.
//

import Foundation
import AVFoundation


class AudioMantraDetailsViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var questionList: NotesQuestionsIDS = NotesQuestionsIDS()
    @Published var questionIds: [QuestionIdsStringElement] = [QuestionIdsStringElement]()
    @Published var question: NoteQuestionResponseElement = NoteQuestionResponseElement()
    @Published var pendingQuestions: [QuestionIdsStringElement] = [QuestionIdsStringElement]()
    @Published var knownQuestions: [QuestionIdsStringElement] = [QuestionIdsStringElement]()
    @Published var bookmarkedQuestions: [QuestionIdsStringElement] = [QuestionIdsStringElement]()
    @Published var index = 0
    @Published var isFrom: questionIsFrom = .toRead
    @Published var isPlaying = false
    @Published var isBack = false
    @Published var alertItem: AlertItem?
    
    
    var player: AVPlayer?
    
    private var playerObserver: Any?
    
    
    var duration: String {
        
        if player?.currentItem?.status == .readyToPlay {
            
            guard let duration = player?.currentItem?.duration else { return "0:00" }
            let durationInSeconds = Int(CMTimeGetSeconds(duration))
            if Double(durationInSeconds).isFinite {
                let minutes = durationInSeconds / 60
                let seconds = durationInSeconds % 60
                return String(format: "%d:%02d", minutes, seconds)
            } else {
                return "0:00"
            }
            
        } else {
            return "0:00"
        }
        
        
    }
    
    
    func initPlayer(url: URL) {
        player = AVPlayer(url: url)
        playerObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            if let currentItem = self.player?.currentItem {
                if time == currentItem.duration {
                    self.isPlaying = false
                }
            }
        }
    }
    
    deinit {
        if let observer = playerObserver {
            player?.removeTimeObserver(observer)
        }
    }
    
    func play() {
        player?.play()
        isPlaying = true
        
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
        
    }
    
    func getSubjectQuestions(subjectId: String) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        guard let url = URL.getAudioMantraQuestionList(userId: phoneNumber, subjectId: subjectId) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: NotesQuestionsIDS.self) { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let response {
                        
                        if response.isEmpty {
                            self?.getSubjectQuestionList(subjectId: subjectId)
                            return
                        }
                        
                        switch self?.isFrom {
                        case .toRead:
                            self?.questionIds = response.first?.questionsList ?? []
                        case .iKnow:
                            self?.questionIds = response.first?.known ?? []
                        case .bookmared:
                            self?.questionIds = response.first?.bookmarked ?? []
                        case .none:
                            break
                        }
                        
                        
                        self?.bookmarkedQuestions = response.first?.bookmarked ?? []
                        self?.pendingQuestions = response.first?.questionsList ?? []
                        self?.knownQuestions = response.first?.known ?? []
                        
                        
                        if self?.questionIds.isEmpty == false {
                            self?.getQuestion(subjectId: subjectId)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    
                    self?.isLoading = false
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
    
    
    func getSubjectQuestionList(subjectId: String) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        guard let url = URL.getNotesOfSubjectList(subjectId: subjectId) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: [QuestionIDSResponseElement].self) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            switch result {
            case .success(let response):
                if let response {
                    var ids = [QuestionIdsStringElement]()
                    for index in 0..<response.count {
                        let data = response[index].id?.description
                        ids.append(QuestionIdsStringElement(id: data))
                    }
                    
                    DispatchQueue.main.async {
                        self?.questionIds = ids
                        self?.pendingQuestions = ids
                        
                        if self?.questionIds.isEmpty == false {
                            self?.getQuestion(subjectId: subjectId)
                        }
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
    
    
    func getQuestion(subjectId: String) {
        DispatchQueue.main.async {
            self.isLoading = false
        }
        guard let url = URL.getNoteQuestionData(subjectId: subjectId, questionId: questionIds[index].id ?? "") else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: NoteQuestionResponse.self) { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if let question = response?.first {
                        self?.question = question
                        guard let url = URL(string: question.mantra ?? "") else { return }
                        self?.initPlayer(url: url)
                    }
                }
            case .failure(let error):
                debugPrint(error)
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
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
    
    
    //MARK: Update Question
    
    func updateIknowOrBookmarked(subjectId: String, isBookmarked: Bool) {
        
        let data = QuestionIdsStringElement(id: questionIds[index].id ?? "")
        
        if isBookmarked {
            if !bookmarkedQuestions.contains(where: { $0.id == data.id }) {
                bookmarkedQuestions.append(data)
            }
            pendingQuestions.removeAll(where: { $0.id == data.id })
            knownQuestions.removeAll(where: { $0.id == data.id })
        } else {
            if !knownQuestions.contains(where: { $0.id == data.id }) {
                knownQuestions.append(data)
            }
            pendingQuestions.removeAll(where: { $0.id == data.id })
            bookmarkedQuestions.removeAll(where: { $0.id == data.id })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.next(subjectId: subjectId)
        }
        
    }
    
    
    func updateDataToServer(subjectId: String, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        let request = NoteQuestionUpdateRequest(bookmarked: bookmarkedQuestions,
                                                known: knownQuestions,
                                                questionsList: pendingQuestions,
                                                subjectName: Int(subjectId),
                                                user: Int(phoneNumber))
        
        guard let url = URL.updateAudioMantraLastSeen() else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        
        HttpUtility.shared.postData(request: urlRequest, resultType: CreateGtRecord.self) { [weak self] (result) in
            switch result {
            case .success(_):
                
                DispatchQueue.main.async {
                    self?.bookmarkedQuestions = []
                    self?.knownQuestions = []
                    self?.pendingQuestions = []
                    self?.isLoading = false
                    completion()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
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
    
    
    func next(subjectId: String) {
        if isPlaying {
            pause()
        }
        
        if index + 1 < questionIds.count {
            DispatchQueue.main.async {
                self.index += 1
                self.getQuestion(subjectId: subjectId)
            }
        } else {
            updateDataToServer(subjectId: subjectId) {
                self.isBack = true
            }
        }
    }
    
    func prev(subjectId: String) {
        if isPlaying {
            pause()
        }
        
        if index <= questionIds.count {
            DispatchQueue.main.async {
                self.index -= 1
                self.getQuestion(subjectId: subjectId)
            }
        }
    }
    
    func skip(subjectId: String) {
        if isPlaying {
            pause()
        }
        
        if index + 1 < questionIds.count {
            DispatchQueue.main.async {
                self.index += 1
                self.getQuestion(subjectId: subjectId)
            }
        } else {
            updateDataToServer(subjectId: subjectId) {
                self.isBack = true
            }
        }
    }
    
}
