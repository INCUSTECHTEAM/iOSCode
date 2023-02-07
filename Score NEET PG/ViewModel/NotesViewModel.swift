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
        
        DispatchQueue.main.async {
            self.notesDataModel.notesList = NotesResponse()
        }
        
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
}
