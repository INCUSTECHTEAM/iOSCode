//
//  NoteQuestionViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 03/12/22.
//

import Foundation
import SwiftUI


struct NoteQuestionDataModel {
    var questionList: NotesQuestionsIDS = NotesQuestionsIDS()
    var questionIds: [QuestionIdsStringElement] = [QuestionIdsStringElement]()
    var question: NoteQuestionResponseElement = NoteQuestionResponseElement()
    var pendingQuestions: [QuestionIdsStringElement] = [QuestionIdsStringElement]()
    var knownQuestions: [QuestionIdsStringElement] = [QuestionIdsStringElement]()
    var bookmarkedQuestions: [QuestionIdsStringElement] = [QuestionIdsStringElement]()
    var index = 0
    var isFrom: questionIsFrom = .toRead
    var isLoading = false
    var noDataAlertPresent = false
    var isBack = false
}


class NoteQuestiosnViewModel: ObservableObject {
    
    @Published var noteQuestionDataModel: NoteQuestionDataModel = NoteQuestionDataModel()
    
    func next(subjectId: String) {
        if noteQuestionDataModel.index + 1 < noteQuestionDataModel.questionIds.count {
            DispatchQueue.main.async {
                self.noteQuestionDataModel.index += 1
                self.getQuestion(subjectId: subjectId)
            }
        } else {
            updateDataToServer(subjectId: subjectId) {
                self.noteQuestionDataModel.isBack = true
            }
        }
    }
    
    func prev(subjectId: String) {
        if noteQuestionDataModel.index <= noteQuestionDataModel.questionIds.count {
            DispatchQueue.main.async {
                self.noteQuestionDataModel.index -= 1
                self.getQuestion(subjectId: subjectId)
            }
        }
    }
    
    func updateIknowOrBookmarked(subjectId: String, isBookmarked: Bool) {
        
        let data = QuestionIdsStringElement(id: noteQuestionDataModel.questionIds[noteQuestionDataModel.index].id ?? "")
        
        if isBookmarked {
            if !noteQuestionDataModel.bookmarkedQuestions.contains(where: { $0.id == data.id }) {
                noteQuestionDataModel.bookmarkedQuestions.append(data)
            }
            noteQuestionDataModel.pendingQuestions.removeAll(where: { $0.id == data.id })
            noteQuestionDataModel.knownQuestions.removeAll(where: { $0.id == data.id })
        } else {
            if !noteQuestionDataModel.knownQuestions.contains(where: { $0.id == data.id }) {
                noteQuestionDataModel.knownQuestions.append(data)
            }
            noteQuestionDataModel.pendingQuestions.removeAll(where: { $0.id == data.id })
            noteQuestionDataModel.bookmarkedQuestions.removeAll(where: { $0.id == data.id })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.next(subjectId: subjectId)
        }
        
    }
    
    
    
    
    
    func updateDataToServer(subjectId: String, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.noteQuestionDataModel.isLoading = true
        }
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        let request = NoteQuestionUpdateRequest(bookmarked: noteQuestionDataModel.bookmarkedQuestions,
                                                known: noteQuestionDataModel.knownQuestions,
                                                questionsList: noteQuestionDataModel.pendingQuestions,
                                                subjectName: Int(subjectId),
                                                user: Int(phoneNumber))
        
        
        
        guard let url = URL.updateNoteLastSeen() else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        
        HttpUtility.shared.postData(request: urlRequest, resultType: CreateGtRecord.self) { [weak self] (result) in
            switch result {
            case .success(_):
               
                DispatchQueue.main.async {
                    self?.noteQuestionDataModel.bookmarkedQuestions = []
                    self?.noteQuestionDataModel.knownQuestions = []
                    self?.noteQuestionDataModel.pendingQuestions = []
                    self?.noteQuestionDataModel.isLoading = false
                    completion()
                }
            case .failure(_):
                self?.noteQuestionDataModel.isLoading = false
            }
        }
        
        
        
    }
    
    func getSubjectQuestionList(subjectId: String) {
        DispatchQueue.main.async {
            self.noteQuestionDataModel.isLoading = true
        }
        
        guard let url = URL.getNotesOfSubjectList(subjectId: subjectId) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: [QuestionIDSResponseElement].self) { [weak self] (result) in
            self?.noteQuestionDataModel.isLoading = false
            switch result {
            case .success(let response):
                    if let response {
                        var ids = [QuestionIdsStringElement]()
                        for index in 0..<response.count {
                            let data = response[index].id?.description
                            ids.append(QuestionIdsStringElement(id: data))
                        }
                        
                        DispatchQueue.main.async {
                            self?.noteQuestionDataModel.questionIds = ids
                            self?.noteQuestionDataModel.pendingQuestions = ids
                            
                            if self?.noteQuestionDataModel.questionIds.isEmpty == false {
                                self?.getQuestion(subjectId: subjectId)
                            }
                        }
                    }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getSubjectQuestions(subjectId: String) {
        DispatchQueue.main.async {
            self.noteQuestionDataModel.isLoading = true
        }
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        guard let url = URL.getNotesQuestionsList(userId: phoneNumber, subjectId: subjectId) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: NotesQuestionsIDS.self) { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.noteQuestionDataModel.isLoading = false
                    if let response {
                        
                        if response.isEmpty {
                            self?.getSubjectQuestionList(subjectId: subjectId)
                            return
                        }
                        
                        switch self?.noteQuestionDataModel.isFrom {
                        case .toRead:
                            self?.noteQuestionDataModel.questionIds = response.first?.questionsList ?? []
                        case .iKnow:
                            self?.noteQuestionDataModel.questionIds = response.first?.known ?? []
                        case .bookmared:
                            self?.noteQuestionDataModel.questionIds = response.first?.bookmarked ?? []
                        case .none:
                            break
                        }


                        self?.noteQuestionDataModel.bookmarkedQuestions = response.first?.bookmarked ?? []
                        self?.noteQuestionDataModel.pendingQuestions = response.first?.questionsList ?? []
                        self?.noteQuestionDataModel.knownQuestions = response.first?.known ?? []
                        
                        
                        if self?.noteQuestionDataModel.questionIds.isEmpty == false {
                            self?.getQuestion(subjectId: subjectId)
                        }
                    }
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self?.noteQuestionDataModel.isLoading = false
            }
        }
    }
    
    func getQuestion(subjectId: String) {
        noteQuestionDataModel.isLoading = true
        guard let url = URL.getNoteQuestionData(subjectId: subjectId, questionId: noteQuestionDataModel.questionIds[noteQuestionDataModel.index].id ?? "") else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: NoteQuestionResponse.self) { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.noteQuestionDataModel.isLoading = false
                    if let question = response?.first {
                        self?.noteQuestionDataModel.question = question
                    }
                }
            case .failure(let error):
                debugPrint(error)
                self?.noteQuestionDataModel.isLoading = false
            }
        }
        
    }
    
    func deleteAudio(request: DeleteAudioRequest, audioId: String, completion: @escaping () -> Void) {
        guard let url = URL.notesTestAudio(audioId: audioId) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        
        HttpUtility.shared.postData(request: urlRequest, resultType: AudioResponse.self) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    
    func uploadAudioRecording(audio: String, completion: @escaping () -> Void) {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        
        noteQuestionDataModel.isLoading = true
        
        let request = RecordingUpdateRequest(fact: noteQuestionDataModel.question.id ?? 0, audio: audio, user: phoneNumber)
        
        guard let url = URL.noteTestAudioCreate() else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        
        
        HttpUtility.shared.postData(request: urlRequest, resultType: AudioResponse.self) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    print("COmment Added")
                    completion()
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
}


//ENUM

enum questionIsFrom: String {
    case toRead = "ToRead"
    case iKnow = "IKnow"
    case bookmared = "Bookmarked"
}



