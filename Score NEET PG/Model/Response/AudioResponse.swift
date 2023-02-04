//
//  AudioResponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 12/12/22.
//

import Foundation

// MARK: - AudioResponse
struct AudioResponse: Codable {
    var id: Int?
    var audio: String?
    var valid: Bool?
    var fact: Int?
    var user: String?
}
