//
//  AudioMantraListResponse.swift
//  Score NEET PG
//
//  Created by Rahul on 13/04/23.
//

import Foundation


// MARK: - AudioMantraListResponse
struct AudioMantraListResponse: Codable {
    let data: [AudioMantraListData]
    let stats: Stats
}

// MARK: - Datum
struct AudioMantraListData: Codable {
    let subjectName: String
    let id, bookmarked, known, remaining: Int
    let total: Int

    enum CodingKeys: String, CodingKey {
        case subjectName = "subject_name"
        case id, bookmarked, known, remaining, total
    }
}


