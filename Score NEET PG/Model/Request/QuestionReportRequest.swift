//
//  QuestionReportRequest.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 10/02/23.
//

import Foundation

struct QuestionReportRequest: Codable {
    let id: String
    let user: String
    
    enum CodingKeys: String, CodingKey {
        case id = "block"
        case user = "user"
    }
}


// MARK: - News
struct QuestionReportResponse: Codable {
    var id: AnyCodableValue?
    var solved: AnyCodableValue?
    var block: AnyCodableValue?
    var user: AnyCodableValue?
}
