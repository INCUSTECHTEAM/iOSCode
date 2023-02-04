//
//  RightWrongQuestion.swift
//  Score MLE
//
//  Created by ios on 30/07/22.
//

import Foundation

// MARK: - RightWrongQuestion
struct RightWrongQuestion: Codable {
    let questionCode: Int?
    let questionName, answer, questionImageURL, userAnswer: String?
    let optionA, optionB, optionC, optionD: String?
    let explanation, explanationImages: String?
    let subjectName: Int?
    let subjectDisplayName: String?

    enum CodingKeys: String, CodingKey {
        case questionCode, questionName, answer, questionImageURL, userAnswer, optionA, optionB, optionC, optionD, explanation, explanationImages
        case subjectName = "subject_name"
        case subjectDisplayName = "subject_display_name"
    }
}

typealias RightWrongQuestions = [RightWrongQuestion]
