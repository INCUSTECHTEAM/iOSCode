//
//  MockTestResponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import Foundation

// MARK: - MockTestResponseElement
struct MockTestResponseElement: Codable {
    var id: Int?
    var testName: String?
    var valid: Bool?
    var mode: String?
    var createdDate: String?
    var startDate: String?
    var completed: Bool?
    var resume: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case testName = "test_name"
        case valid, mode
        case createdDate = "created_date"
        case startDate = "start_date"
        case completed
        case resume
    }
}

typealias MockTestResponse = [MockTestResponseElement]
