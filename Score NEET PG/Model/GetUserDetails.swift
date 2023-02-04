//
//  GetUserDetails.swift
//  Score MLE
//
//  Created by ios on 29/07/22.
//

import Foundation

// MARK: - UserDetailsResponse
struct UserDetailsResponse: Codable {
    let userLst: [UserList]?
    let state: Bool
    let message: String
}

// MARK: - UserLst
struct UserList: Codable {
    let userID, name: String?
    let imageURL: String?
    let countryCode, mobileNumber, userName, gcmID, userComment: String?
    let subscriptionExpiration: String?
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case name, imageURL, countryCode, mobileNumber, userName, userComment
        case gcmID = "gcmId"
        case subscriptionExpiration = "bio"
    }
}


// MARK: - User
struct User: Codable {
    let username: String?
    let id: Int?
    let firstName, lastName: String?
    let photo: String?
    let paid: Bool?
    let paymentExpiryDate: String?
    let detail: String?
    let is_staff: Bool?
    enum CodingKeys: String, CodingKey {
        case username, id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo, paid
        case paymentExpiryDate = "payment_expiry_date"
        case detail
        case is_staff
    }
}
