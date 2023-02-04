//
//  QuestionUpdateRequest.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 02/12/22.
//

import Foundation

struct QuestionUpdateRequest: Encodable {
    var user: String
    var question: String
    var score: String
    var choosenOption: String
    var gt: String
}
