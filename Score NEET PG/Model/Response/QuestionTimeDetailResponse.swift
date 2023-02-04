//
//  QuestionTimeDetailResponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 02/12/22.
//

import Foundation

// MARK: - QuestionTimeDetailResponseElement
struct QuestionTimeDetailResponseElement: Codable {
    var completed: Bool?
    var timeTook: Int?

    enum CodingKeys: String, CodingKey {
        case completed
        case timeTook = "time_took"
    }
}

typealias QuestionTimeDetailResponse = [QuestionTimeDetailResponseElement]

