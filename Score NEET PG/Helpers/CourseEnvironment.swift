//
//  AppStorage.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 09/02/23.
//

import Foundation

class CourseEnvironment {
    
    private init() { }
    static let shared = CourseEnvironment()
    
    func set(isNeetPG: Bool) {
        UserDefaults.standard.set(isNeetPG, forKey: "isNeetPG")
    }
    
    func isNeetPG() -> Bool {
        return UserDefaults.standard.bool(forKey: "isNeetPG")
    }
}
