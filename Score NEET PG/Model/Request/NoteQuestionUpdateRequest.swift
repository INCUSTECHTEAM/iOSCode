//
//  NoteQuestionUpdateRequest.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 06/12/22.
//

import Foundation

// MARK: - NoteQuestionUpdateRequest
struct NoteQuestionUpdateRequest: Codable {
    var bookmarked, known, questionsList: [QuestionIdsStringElement]?
    var subjectName, user: Int?

    enum CodingKeys: String, CodingKey {
        case bookmarked, known
        case questionsList = "questions_list"
        case subjectName = "subject_name"
        case user
    }
}


