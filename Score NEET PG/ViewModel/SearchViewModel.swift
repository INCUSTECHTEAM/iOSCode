//
//  SearchViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 12/01/23.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    
    private let debouncer = Debouncer(timeInterval: 0.5)
    @Published var isAvailableToSearch = false
    @Published var searchText: String = ""
    @Published var tabs: [TopTab] = [.init(title: "MCQ's"),
                                     .init(title: "Notes")]
    @Published var selectedTab: Int = 0
    
    //MARK: Properties for mock test
    @Published var currentQuestionIndex: Int = 0
    @Published var questions: [MockTestSearchResult] = []
    @Published var currentQuestion: QuestionDetail?
    
    //MARK: Properties for notes
    @Published var notes: NotesSearch = []
    @Published var currentNoteIndex: Int = 0
    @Published var currentNote: NoteQuestionResponse?
    
    @Published private var group = DispatchGroup()
    @Published private var task: URLSessionDataTask?
    @Published var isLoading = false
    @Published var noResultFound = false
    @Published var item: Item? = nil
    
    func addParams(to url: URL, params: [String: String]) -> URL? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    func performSearch() {
        
        guard searchText.isEmpty == false else { return }
        
        currentNote = nil
        currentQuestion = nil
        
        let searchQueue = DispatchQueue(label: "searchQueue")
        searchQueue.async {
            switch self.selectedTab {
            case 0:
                self.performMockTestSearch()
            case 1:
                self.performNoteSearch()
            default: break
            }
        }
    }
    
    
    private func performMockTestSearch() {
        loadingStart()
        
        guard !self.searchText.isEmpty else {
            self.questions = []
            return
        }
        
        
        guard let url = URL.searchMockTest() else { return }
        
        let params = ["search": searchText]
        
        guard let updatedURL = self.addParams(to: url, params: params) else { return }
        
        var urlRequest = URLRequest(url: updatedURL)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: [MockTestSearchResult].self) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let response {
                        if response.count == 0 {
                            self.noResultFound = true
                        }
                        self.questions = response
                        self.getQuestion(questionId: response.first?.id?.description ?? "")
                    } else {
                        print("Getting Error while search")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func loadingStart() {
        DispatchQueue.main.async {
            self.noResultFound = false
            self.isLoading = true
        }
    }
    
    private func performNoteSearch() {
        
        guard !self.searchText.isEmpty else {
            self.notes = []
            return
        }
        
        loadingStart()
        
        
        guard let url = URL.searchNotes() else { return }
        
        let params = ["search": searchText]
        
        guard let updatedURL = self.addParams(to: url, params: params) else { return }
        
        var urlRequest = URLRequest(url: updatedURL)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: NotesSearch.self) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let response {
                        if response.count == 0 {
                            self.noResultFound = true
                        }
                        self.notes = response
                        self.getNotes(subjectId: response.first?.subjectName?.description ?? "", noteId: response.first?.id?.description ?? "")
                    } else {
                        print("Getting Error while search")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
        
    }
    
    
    func createSearchHistory() {
        guard !searchText.isEmpty else { return }
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        guard let url = URL.getSearchHistory() else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        let createRequest = SearchHistoryElement(word: searchText, user: phoneNumber)
        urlRequest.httpBody = try? JSONEncoder().encode(createRequest)
        
        HttpUtility.shared.postData(request: urlRequest, resultType: SearchHistoryElement.self) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                break
            }
        }
    }
    
    
    func getQuestion(questionId: String) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        guard let url = URL.getQuestion(questionId: questionId) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        group.enter()
        task?.cancel()
        
        task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if let error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                self.group.leave()
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                // Handle the error
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                self.group.leave()
                return
            }
            
            if let data {
                do {
                    let question = try JSONDecoder().decode(QuestionDetail.self, from: data)
                    DispatchQueue.main.async {
                        self.currentQuestion = question
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            }
            self.group.leave()
        })
        task?.resume()
    }
    
    
    //MARK: Get Note
    
    func getNotes(subjectId: String, noteId: String) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        guard let url = URL.getNoteQuestionData(subjectId: subjectId, questionId: noteId) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: NoteQuestionResponse.self) { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.currentNote = response
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
                debugPrint(error)
            }
        }
        
    }
    
    
    //MARK: Delete Audio
    
    func deleteAudio(audioId: String) {
        
        guard let url = URL.grandTestAudio(audioId: audioId) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(DeleteAudioRequest())
        
        HttpUtility.shared.postData(request: urlRequest, resultType: AudioResponse.self) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.performSearch()
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    //MARK: Next and Prev function
    func nextQuestion() {
        switch selectedTab {
        case 0:
            guard currentQuestionIndex < questions.count else { return }
            currentQuestionIndex += 1
            getQuestion(questionId: questions[currentQuestionIndex].id?.description ?? "")
        case 1:
            guard currentNoteIndex < notes.count else { return }
            currentNoteIndex += 1
            let note = notes[currentNoteIndex]
            getNotes(subjectId: note.subjectName?.description ?? "", noteId: note.id?.description ?? "")
        default: break
        }
        
    }
    
    func prevQuestion() {
        switch selectedTab {
        case 0:
            guard currentQuestionIndex > 0 else { return }
            currentQuestionIndex -= 1
            getQuestion(questionId: questions[currentQuestionIndex].id?.description ?? "")
        case 1:
            guard currentNoteIndex > 0 else { return }
            currentNoteIndex -= 1
            let note = notes[currentNoteIndex]
            getNotes(subjectId: note.subjectName?.description ?? "", noteId: note.id?.description ?? "")
        default: break
        }
        
    }
    
    //MARK: Check Answer
    
    func answerColor(option: String) -> Color {
        
        if let correctAnswer = currentQuestion?.correctAnswer, correctAnswer.uppercased() == option || correctAnswer.uppercased().contains(option) {
            return .answerCorrectColor
        }
        
        //        if let incorrectAnswer = currentQuestion.userAnswer, incorrectAnswer.uppercased() == option || incorrectAnswer.uppercased().contains(option) {
        //            return .answerWrongColor
        //        }
        
        return Color.gray.opacity(0.15)
    }
    
    func calculateQuestionCount() -> (Int, Int) {
        switch selectedTab {
        case 0: return (currentQuestionIndex+1, questions.count)
        case 1: return (currentNoteIndex+1, notes.count)
        default: return (0, 0)
        }
    }
    
    func updatePaymentStatus() {
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        NetworkManager.shared.getUser(mobileNumber: phoneNumber) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    UserSession.userSessionInstance.setSubscriptionExpiry(expiryDate: data.paymentExpiryDate ?? "")
                    if let staff = data.is_staff {
                        withAnimation {
                            isStaff = staff
                        }
                    }
                    if data.paid == true {
                        paymentStatus = true
                        self.isAvailableToSearch = true
                    } else {
                        if UserSession.userSessionInstance.getSubscriptionStatus() {
                            paymentStatus = true
                            self.isAvailableToSearch = true
                        } else {
                            paymentStatus = false
                            self.isAvailableToSearch = false
                        }
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("failure \(error.localizedDescription)")
                }
            }
        }
        
    }
    
}
