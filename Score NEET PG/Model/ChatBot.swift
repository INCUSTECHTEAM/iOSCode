//
//  ChatBot.swift
//  Score MLE
//
//  Created by ios on 29/07/22.
//

import SwiftUI

// MARK: - ChatBotElement
struct ChatBotElement: Identifiable, Codable {
    let id = UUID()
    let recipientID: String?
    let custom: Custom?
    let image: ImageValue?
    let text: String?
    let buttons: [ChatBotButton]?
    @State var isTyping = false
    
    enum CodingKeys: String, CodingKey {
        case recipientID = "recipient_id"
        case custom, text, buttons, image
    }
}

// MARK: - Button
struct ChatBotButton: Codable {
    
    let id = UUID()
    let title: String?
    let payload: Payload?
   
}


enum Payload: Codable {
    case integer(Int)
    case double(Double)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Payload.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Payload"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

extension Payload {
    
    var stringValue: String? {
        switch self {
        case .integer(let value): return String(value)
        case .double(let value): return String(value)
        case .string(let value): return value
        }
    }
    
}


// MARK: - Custom
struct Custom: Codable {
    let gif: GIF?
    let graph: [String: Int]?
    let video: Video?
    let AndroidButton: String?
    let fullGraph: [FullGraph]?
    let singleGraph: FullGraph?
    
    enum CodingKeys: String, CodingKey {
        case fullGraph = "full_graph"
        case singleGraph = "single_graph"
        case gif, graph, video, AndroidButton
    }
    
}

// MARK: - FullGraph
struct FullGraph: Codable {
    let ra, sa, wa, score: Int
    let subName: String
    let subScore: Int

    enum CodingKeys: String, CodingKey {
        case ra, sa, wa, score
        case subName = "sub_name"
        case subScore = "sub_score"
    }
}


// MARK: - GIF
struct GIF: Codable {
    let link: String?
}

enum Video: Codable {
    case integer(Int)
    case double(Double)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Video.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Video"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

extension Video {
    
    var stringValue: String? {
        switch self {
        case .integer(let value): return String(value)
        case .double(let value): return String(value)
        case .string(let value): return value
        }
    }
    
}


enum ImageValue: Codable {
    case integer(Int)
    case double(Double)
    case string(String)
    case array([String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode([String].self) {
            self = .array(x)
            return
        }
        throw DecodingError.typeMismatch(ImageValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Image"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .array(let x):
            try container.encode(x)
        }
    }
}

extension ImageValue {
    
    var arrayValue: [String]? {
        switch self {
        case .integer(let value): return [String(value)]
        case .double(let value): return [String(value)]
        case .string(let value): return [value]
        case .array(let value): return value
        }
    }
    
}

extension ChatBotElement {
    
    var imageArray: [String]? {
        return image?.arrayValue?.first?.trimmingCharacters(in: .whitespaces).components(separatedBy: ",")
    }
    
}

typealias ChatBot = [ChatBotElement]
