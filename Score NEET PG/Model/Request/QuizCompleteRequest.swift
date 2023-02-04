//
//  QuizCompleteRequest.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 05/12/22.
//

import Foundation

struct QuizCompleteRequest: Codable {
    var completed: Bool?
    var time_took: Int?
}
