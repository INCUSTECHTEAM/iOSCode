//
//  SubjectMockTestViewModel.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import Foundation

struct SubjectMockTestDataModel {
    var mockTests: MockTestResponse = MockTestResponse()
}

class SubjectMockTestViewModel: ObservableObject {
    
    @Published var subjectMockTestDataModel: SubjectMockTestDataModel = SubjectMockTestDataModel()
    let subjectMockTestResource: SubjectMockTestResource = SubjectMockTestResource()
    
    func getMockTests(id: String) {
        subjectMockTestResource.getMocktests(gtId: id) { [weak self] (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let response {
                        self?.subjectMockTestDataModel.mockTests = response
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
}
