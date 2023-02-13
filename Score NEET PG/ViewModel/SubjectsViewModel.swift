//
//  SubjectsViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 12/02/23.
//

import Foundation

class SubjectsViewModel: ObservableObject {
    
    //MARK: - PROPERTIES
    @Published var subjects = Subject()
    @Published var pptSubjects = Subject()
    @Published var searchText = ""
    @Published var isLoading = false
    
    var filteredSubjects: Subject {
        if searchText.isEmpty {
            return subjects
        } else {
            return subjects.filter { $0.subjectName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    
    //MARK: - FUNCTIONS
    
    func getSubjects() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        NetworkManager.shared.getSubjects { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let subjects):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.subjects = subjects
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error.localizedDescription)
            }
        }
    }
    
    func getSubjectWithPPT() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        NetworkManager.shared.getSubjectsWithPPT { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let subjects):
                DispatchQueue.main.async {
                    self.pptSubjects = subjects
                    self.getSubjects()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error.localizedDescription)
            }
        }
    }
    
}
