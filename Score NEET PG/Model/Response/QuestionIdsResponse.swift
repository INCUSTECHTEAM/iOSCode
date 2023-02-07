//
//  QuestionIdsResponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 02/12/22.
//

import Foundation

// MARK: - QuestionIDSResponseElement
struct QuestionIDSResponseElement: Codable {
    var id: Int?
}



typealias QuestionIDSResponse = [QuestionIDSResponseElement]

struct QuestionIdsStringElement: Codable, Equatable {
    var id: String?
}

