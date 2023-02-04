//
//  PPT.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 27/09/22.
//

import Foundation

// MARK: - PPTListElement
struct PPTListElement: Codable {
    let id: Int?
    let tag: String?
    let fact: String?
}

typealias PPTList = [PPTListElement]


// MARK: - PPTElement
struct PPTElement: Codable {
    let id: Int?
    let fact, image, cat, pptFor: String?
    let ppt: String?
    let subjectName: Int?

    enum CodingKeys: String, CodingKey {
        case id, fact, image, cat
        case pptFor = "_for"
        case ppt
        case subjectName = "subject_name"
    }
}

typealias Ppt = [PPTElement]
