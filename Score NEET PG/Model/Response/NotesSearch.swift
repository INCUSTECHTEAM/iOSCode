//
//  HyfSearchResult.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 12/01/23.
//

import Foundation

// MARK: - HyfSearchElement
struct NoteSearchElement: Codable {
    var factTruncated: String?
    var id, subjectName: Int?

    enum CodingKeys: String, CodingKey {
        case factTruncated = "fact_truncated"
        case id
        case subjectName = "subject_name"
    }
}

typealias NotesSearch = [NoteSearchElement]
