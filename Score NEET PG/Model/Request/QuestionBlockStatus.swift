//
//  QuestionBlockStatus.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 04/02/23.
//

import Foundation

// MARK: - News
struct QuestionBlockStatus: Codable {
    var id: Int?
    var choosenAnswer, createdDate: String?
    var status: Bool?
    var block: Int?
    var user: String?

    enum CodingKeys: String, CodingKey {
        case id, choosenAnswer
        case createdDate = "created_date"
        case status, block, user
    }
}
