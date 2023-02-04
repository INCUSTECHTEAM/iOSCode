//
//  PauseQuestionRequest.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 05/12/22.
//

import Foundation

// MARK: - PauseQuestionRequest
struct PauseQuestionRequest: Codable {
    var wrongAnswers, rightAnswers, skipAnswers, questionsList: [QuestionIDSResponseElement]?
    var payload: PayloadData?
    var user, gt: String?

    enum CodingKeys: String, CodingKey {
        case wrongAnswers = "wrong_answers"
        case rightAnswers = "right_answers"
        case skipAnswers = "skip_answers"
        case questionsList = "questions_list"
        case payload, user, gt
    }
}

// MARK: - Payload
struct PayloadData: Codable {
}
