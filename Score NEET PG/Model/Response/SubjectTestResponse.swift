//
//  SubjectTestResponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import Foundation

// MARK: - SubjectResponseElement
struct SubjectTestResponseElement: Codable {
    var name: String?
     var id, totalTopics, totalQuestion, totalSubjectTests: Int?

     enum CodingKeys: String, CodingKey {
         case name, id
         case totalTopics = "total_topics"
         case totalQuestion = "total_question"
         case totalSubjectTests = "total_subject_tests"
     }
}

typealias SubjectTestResponse = [SubjectTestResponseElement]
