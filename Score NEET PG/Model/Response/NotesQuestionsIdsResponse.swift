//
//  NotesQuestionsIds.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 03/12/22.
//

import Foundation

// MARK: - NotesQuestionsID
struct NotesQuestionsID: Codable {
    var id: Int?
    var bookmarked, known, unknown, questionsList: [QuestionIdsStringElement]?
    var subjectName, user: AnyCodableValue?

    enum CodingKeys: String, CodingKey {
        case id, bookmarked, known, unknown
        case questionsList = "questions_list"
        case subjectName = "subject_name"
        case user
    }
}

typealias NotesQuestionsIDS = [NotesQuestionsID]

