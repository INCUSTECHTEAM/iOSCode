//
//  GetUserGtDetailReponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 02/12/22.
//

import Foundation

// MARK: - GetUserGtDetailElement
struct GetUserGtDetailElement: Codable {
    var id: Int?
    var questionText: String?
    var questionImageURL: String?
    var userAnswer: String?
    var correctAnswer, optionA, optionB, optionC: String?
    var optionD, optionE, explanation: String?
    var explanationImages: String?
    var subjectName: Int?
    var subjectDisplayName: String?
    var score: Int?
    var audio: [AudioData]?

    enum CodingKeys: String, CodingKey {
        case id
        case questionText, questionImageURL, userAnswer, correctAnswer, optionA, optionB, optionC, optionD, optionE, explanation, explanationImages
        case subjectName = "subject_name"
        case subjectDisplayName = "subject_display_name"
        case score
        case audio
    }
}

typealias GetUserGtDetailResponse = [GetUserGtDetailElement]
