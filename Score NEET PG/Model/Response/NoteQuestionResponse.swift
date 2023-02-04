//
//  NoteQuestionResponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 03/12/22.
//

import Foundation
import SwiftUI

// MARK: - NoteQuestionResponseElement
struct NoteQuestionResponseElement: Codable {
    var id: Int?
    var fact, image, cat: String?
    var video: JSONNull?
    var noteQuestionResponseFor: String?
    var tag, ppt: JSONNull?
    var subjectName: Int?
    var course: JSONNull?
    var audio: [AudioData]?
    var questions: [QuestionDetail]?

    enum CodingKeys: String, CodingKey {
        case id, fact, image, cat, video
        case noteQuestionResponseFor = "_for"
        case tag, ppt
        case subjectName = "subject_name"
        case course
        case audio
        case questions
    }
}

extension NoteQuestionResponseElement {
    var markDownText: LocalizedStringKey {
        return "\(fact?.replacingOccurrences(of: "\n2**.", with: "\n2 **") ?? "")"
    }
}

typealias NoteQuestionResponse = [NoteQuestionResponseElement]
