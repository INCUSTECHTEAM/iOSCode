//
//  GtLeaderboardResponse.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 01/12/22.
//

import Foundation

// MARK: - GtLeaderboardElement
struct GtLeaderboardElement: Codable {
    var user: LeaderboardUser?
    var score: Int?
}

// MARK: - User
struct LeaderboardUser: Codable {
    var username: String?
    var id: Int?
    var firstName: String?
    var lastName: String?
    var photo: String?
    var paid: Bool?
    var paymentExpiryDate: String?
    var origin: String?

    enum CodingKeys: String, CodingKey {
        case username, id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo, paid
        case paymentExpiryDate = "payment_expiry_date"
        case origin
    }
}

typealias GtLeaderboard = [GtLeaderboardElement]
