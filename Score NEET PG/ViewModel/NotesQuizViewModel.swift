//
//  File.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 03/02/23.
//

import Foundation
import SwiftUI


class NotesQuizViewModel: ObservableObject {
    
    @Published var questions: [QuestionDetail]
    var currentIndex: Int = 0
    @Published var currentQuestion: QuestionDetail?
    @Published var isQuestionAttempt: Bool = false
    @Published var goBack: Bool = false
    @Published var userAnswer: String?
    var answeredCorrectly: [Int: Bool] = [:]
    
    init(questions: [QuestionDetail]) {
        self.questions = questions
        self.currentQuestion = self.questions.first
        
    }
    
    
    
    func nextQuestion() {
        if currentIndex < questions.count - 1 {
            DispatchQueue.main.async {
                self.currentIndex += 1
                self.isQuestionAttempt = false
                self.userAnswer = nil
                self.currentQuestion = self.questions[self.currentIndex]
            }
        } else {
            goBack.toggle()
        }
    }
    
    func updateBlockStatus() {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        let request = QuestionBlockStatus(choosenAnswer: userAnswer, status: true, block: currentQuestion?.id, user: phoneNumber)
        
        guard let url = URL.blockStatus() else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        
        HttpUtility.shared.postData(request: urlRequest, resultType: QuestionBlockStatus.self) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func setNoteBookmarkedStatus() -> Bool {
        if answeredCorrectly.filter({ $0.value == false }).count > 0 {
            return true
        }
        return false
    }
    
    func prevQuestion() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        DispatchQueue.main.async {
            self.currentQuestion = self.questions[self.currentIndex]
        }
    }
    
    func attemptAnswers() {
        if checkAnswer() {
            answeredCorrectly[currentIndex] = true
            return
        }
        answeredCorrectly[currentIndex] = false
    }
    
    func checkAnswer() -> Bool {
        guard let correctAnswer = currentQuestion?.correctAnswer else { return false }
        
        if self.userAnswer == correctAnswer {
            return true
        }
        
        if correctAnswer.uppercased().contains(self.userAnswer?.uppercased() ?? "") {
            return true
        }
        
        if correctAnswer.count == 1 {
            if correctAnswer.uppercased().contains(self.userAnswer?.components(separatedBy: ".").first ?? "") {
                return true
            }
        }
        
        if correctAnswer.components(separatedBy: ", ").contains(self.userAnswer ?? "") {
            return true
        }
        
        if correctAnswer.components(separatedBy: ", ").contains(self.userAnswer?.components(separatedBy: ".").first ?? "") {
            return true
        }
        
        if let userAnswer = self.userAnswer, correctAnswer.components(separatedBy: ", ").contains(userAnswer) {
            return true
        }
        
        return false
    }
    
}
