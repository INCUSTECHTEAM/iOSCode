//
//  QuestionDetailResponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 02/12/22.
//

import Foundation

// MARK: - QuestionDetail
struct QuestionDetail: Codable {
    var id: Int?
    var questionText, image, video: String?
    var audio: [AudioData]?
    var optionAText: String?
    var optionAImage: JSONNull?
    var optionBText: String?
    var optionBImage: JSONNull?
    var optionCText: String?
    var optionCImage: JSONNull?
    var optionDText: String?
    var optionDImage, optionEImage: JSONNull?
    var optionEText: String?
    var correctAnswer: String?
    var timeLimit: Int?
    var explanation, explanationImages, createdDate: String?
    var subjectName: Int?
    //var topic: JSONNull?
    var grandTest: Int?

    enum CodingKeys: String, CodingKey {
        case id, questionText, image, video, audio, optionAText, optionAImage, optionBText, optionBImage, optionCText, optionCImage, optionDText, optionDImage, optionEText, optionEImage, correctAnswer, timeLimit, explanation, explanationImages
        case createdDate = "created_date"
        case subjectName = "subject_name"
        //case topic
        case grandTest = "grand_test"
    }
}

// MARK: - Audio
struct AudioData: Codable {
    var id: Int?
    var audio: String?
    var valid: Bool?
    var fact: Int?
    var user: String?
}


// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
