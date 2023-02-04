//
//  MockQuestion.swift
//  Score MLE
//
//  Created by Manoj kumar on 03/08/22.
//
import Foundation

// MARK: - MockQuestionElement
struct MockQuestionElement: Codable {
    let questionText, questionImageURL, userAnswer, correctAnswer: String?
    let optionA, optionB, optionC, optionD: String?
    let explanation, explanationImages: String?
    let subjectName: Int?
    let subjectDisplayName: String?

    enum CodingKeys: String, CodingKey {
        case questionText, questionImageURL, userAnswer, correctAnswer, optionA, optionB, optionC, optionD, explanation, explanationImages
        case subjectName = "subject_name"
        case subjectDisplayName = "subject_display_name"
    }
}

typealias MockQuestion = [MockQuestionElement]
