//
//  MockTest.swift
//  Score MLE
//
//  Created by Manoj kumar on 03/08/22.
//

import Foundation

// MARK: - MockTestElement
struct MockTestElement: Codable {
    let testName: String
    let testID: Int

    enum CodingKeys: String, CodingKey {
        case testName = "test_name"
        case testID = "test_id"
    }
}

typealias MockTest = [MockTestElement]

