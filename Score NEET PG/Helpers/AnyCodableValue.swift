//
//  AnyCodableValue.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 05/12/22.
//

import Foundation

enum AnyCodableValue: Codable {
    case integer(Int)
    case string(String)
    case float(Float)
    case double(Double)
    case boolean(Bool)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        
        if let x = try? container.decode(Float.self) {
            self = .float(x)
            return
        }
        
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        
        if let x = try? container.decode(Bool.self) {
            self = .boolean(x)
            return
        }
        
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        
        if container.decodeNil() {
            self = .string("")
            return
        }
        
        throw DecodingError.typeMismatch(AnyCodableValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .float(let x):
            try container.encode(x)
        case .double(let x):
            try container.encode(x)
        case .boolean(let x):
            try container.encode(x)
        case .null:
            try container.encode(self)
            break
        }
    }
    
    //Get safe Values
    var stringValue: String {
        switch self {
        case .string(let s):
            return s
        case .integer(let s):
            return "\(s)"
        case .double(let s):
            return "\(s)"
        case .float(let s):
            return "\(s)"
        default:
            return ""
        }
    }
    
    var intValue: Int {
        switch self {
        case .integer(let s):
            return s
        case .string(let s):
            return (Int(s) ?? 0)
        case .float(let s):
            return Int(s)
        case .null:
            return 0
        default:
            return 0
        }
    }
    
    var floatValue: Float {
        switch self {
        case .float(let s):
            return s
        case .integer(let s):
            return Float(s)
        case .string(let s):
            return (Float(s) ?? 0)
        default:
            return 0
        }
    }
    
    var doubleValue: Double {
        switch self {
        case .double(let s):
            return s
        case .string(let s):
            return (Double(s) ?? 0.0)
        case .integer(let s):
            return (Double(s))
        case .float(let s):
            return (Double(s))
        default:
            return 0.0
        }
    }
    
    var booleanValue: Bool {
        switch self {
        case .boolean(let s):
            return s
        case .integer(let s):
            return s == 1
        case .string(let s):
            let bool = (Int(s) ?? 0) == 1
            return bool
        default:
            return false
        }
    }
}
