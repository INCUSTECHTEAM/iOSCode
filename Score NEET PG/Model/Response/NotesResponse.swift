//
//  NotesResponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 03/12/22.
//

import Foundation

// MARK: - NotesResponse
struct NotesResponse: Codable {
    var data: [NotesData]?
    var stats: Stats?
}

// MARK: - NotesData
struct NotesData: Codable {
    var subjectName: String?
    var id, bookmarked, known, remaining: Int?
    var total: Int?

    enum CodingKeys: String, CodingKey {
        case subjectName = "subject_name"
        case id, bookmarked, known, remaining, total
    }
}

// MARK: - Stats
struct Stats: Codable {
    var totalCount, totalBookmarked, totalKnown, totalToBeRead: Int?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case totalBookmarked = "total_bookmarked"
        case totalKnown = "total_known"
        case totalToBeRead = "total_to_be_read"
    }
}
