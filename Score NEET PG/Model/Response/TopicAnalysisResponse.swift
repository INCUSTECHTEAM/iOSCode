//
//  TopicAnalysisResponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 05/12/22.
//

import Foundation

// MARK: - TopicAnalysis
struct TopicAnalysis: Codable {
    var attempted: [Unattempted]?
    var unattempted: [Unattempted]?
}

// MARK: - Unattempted
struct Unattempted: Codable {
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

