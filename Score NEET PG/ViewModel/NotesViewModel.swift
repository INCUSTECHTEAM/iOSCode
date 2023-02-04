//
//  NotesViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 03/12/22.
//

import Foundation

struct NotesDataModel {
    var notesList: NotesResponse = NotesResponse()
    var isLoading = false
}

class NotesViewModel: ObservableObject {
    
    @Published var notesDataModel : NotesDataModel = NotesDataModel()
    
    //Call Api
    
    func getNotes() {
        notesDataModel.isLoading = true
        guard let phoneNumber = UserDefaults.standard.string(forKey: UserDetailsKey.mobileNumber) else { return }
        guard let url = URL.getNotesList(userId: phoneNumber) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        HttpUtility.shared.postData(request: urlRequest, resultType: NotesResponse.self) { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.notesDataModel.isLoading = false
                    if let response {
                        self?.notesDataModel.notesList = response
                    }
                }
            case .failure(let error):
                self?.notesDataModel.isLoading = false
                debugPrint(error)
            }
        }
    }
    
    
//    func updateLastSeen(request: QuestionUpdateRequest) {
//        gtQuizResource.createGtRecord(request: request) { [weak self] (result) in
//            switch result {
//            case .success(let response):
//                DispatchQueue.main.async {
//                    if response?.status == true {
//                        //Action
//                        if self?.gtQuizDataModel.questionsIdsList.count ?? 0 > self?.gtQuizDataModel.index ?? 0 {
//                            self?.gtQuizDataModel.index += 1
//                            self?.getQuestion()
//                        }
//
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    print(error)
//                }
//            }
//        }
//    }
    
}
