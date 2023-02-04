//
//  GtListResponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import Foundation

// MARK: - GtlistResponseElement
struct GtlistResponseElement: Codable {
    var testName: String?
    var testID, score, rank, rightAnswers: Int?
    var wrongAnswers, skippedAnswers: Int?

    enum CodingKeys: String, CodingKey {
        case testName = "test_name"
        case testID = "test_id"
        case score, rank
        case rightAnswers = "right_answers"
        case wrongAnswers = "wrong_answers"
        case skippedAnswers = "skipped_answers"
    }
}

typealias GtlistResponse = [GtlistResponseElement]
