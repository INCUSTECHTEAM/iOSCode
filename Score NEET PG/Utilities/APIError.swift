//
//  APIError.swift
//  Score MLE
//
//  Created by ios on 29/07/22.
//

import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
    case decodingError(message: String)
    case customMessage(message: String)
}

