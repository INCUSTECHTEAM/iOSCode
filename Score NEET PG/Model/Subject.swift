//
//  Subject.swift
//  Score NEET PG
//
//  Created by ios on 18/08/22.
//

import Foundation

// MARK: - SubjectElement
struct SubjectElement: Codable, Identifiable {
    let id: Int
    let subjectName, subjectDescription: String

    enum CodingKeys: String, CodingKey {
        case id
        case subjectName = "subject_name"
        case subjectDescription = "subject_description"
    }
}

typealias Subject = [SubjectElement]



// MARK: - HyfElement
struct HyfElement: Codable, Identifiable {
    let id: Int
    let tag: String
    let fact: String
}

typealias Hyf = [HyfElement]


// MARK: - VideoElement
struct VideoElement: Codable {
    let id: Int
    let fact, image, cat, video: String
    let subjectName: Int

    enum CodingKeys: String, CodingKey {
        case id, fact, image, cat, video
        case subjectName = "subject_name"
    }
}
