//
//  AppStorage.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 09/02/23.
//

import Foundation

enum Courses: String {
    case NEETPG = "NEETPG"
    case Nursing = "Nursing"
    case USMLESTEP1 = "USMLE STEP 1"
    case USMLESTEP2 = "USMLE STEP 2"
}

class CourseEnvironment: ObservableObject {
    
    private init() { }
    static let shared = CourseEnvironment()
    
    @Published var refreshed = false
    
    func set(course: Courses) {
        UserDefaults.standard.set(course.rawValue, forKey: "selectedCourses")
    }
    
    func checkSelectedCourse() -> String? {
        refreshed.toggle()
        return UserDefaults.standard.string(forKey: "selectedCourses")
    }
}
