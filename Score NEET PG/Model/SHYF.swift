//
//  SHYF.swift
//  Score MLE
//
//  Created by ios on 30/07/22.
//

import Foundation

// MARK: - ShyfRightWrongQuestion
struct ShyfRightWrongQuestion: Codable {
    let questionCode: Int?
    let questionName: String?
    let questionImageURL: String?
    let questionVideoURL: String?
    let cat: String?
    let userAnswer: String?
    let subjectName: Int?
    let subjectDisplayName: String?

    enum CodingKeys: String, CodingKey {
        case questionCode, questionName, questionImageURL, questionVideoURL, cat, userAnswer
        case subjectName = "subject_name"
        case subjectDisplayName = "subject_display_name"
    }
}


typealias ShyfRightWrongQuestions = [ShyfRightWrongQuestion]
