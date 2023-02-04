//
//  RecordingUpdateRequest.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 12/12/22.
//

import Foundation

struct RecordingUpdateRequest: Encodable {
    var fact: Int
    var audio: String
    var user: String
    var valid: Bool = true
}
