//
//  NotesViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 03/12/22.
//

import Foundation
import SwiftUI

struct NotesDataModel {
    var notesList: NotesResponse = NotesResponse()
    var isLoading = false
}

class NotesViewModel: ObservableObject {
    
    @Published var notesDataModel : NotesDataModel = NotesDataModel()
    @Published var alertItem: AlertItem?
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
                DispatchQueue.main.async {
                    self?.notesDataModel.isLoading = false
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
}
