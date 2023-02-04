//
//  SearchHistory.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 13/01/23.
//

import Foundation

// MARK: - SearchHistoryElement
struct SearchHistoryElement: Codable, Equatable {
    var id: Int?
    var word: String?
    var display: Bool?
    var user: String?
}

typealias SearchHistory = [SearchHistoryElement]
