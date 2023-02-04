//
//  GtAnalysisResponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import Foundation


// MARK: - GtAnalysisResponseElement
struct GtAnalysisResponseElement: Codable {
    var name: String?
    var wrongAnswers, rightAnswers, skippedAnswers, unanswered: Int?
    var score, all: Int?
    var percentage: String?

    enum CodingKeys: String, CodingKey {
        case name
        case wrongAnswers = "wrong_answers"
        case rightAnswers = "right_answers"
        case skippedAnswers = "skipped_answers"
        case unanswered, score, all, percentage
    }
}

typealias GtAnalysisResponse = [GtAnalysisResponseElement]
