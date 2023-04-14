//
//  Constant.swift
//  Score MLE
//
//  Created by ios on 28/07/22.
//

import Foundation
import SwiftUI

// MARK: - GLOBAL VARIABLE

var firebaseUserId = ""
var isEnableBack = true
var isStaff = false


// MARK: - CONSTANT

struct K {
    
    static let neetPGBaseURL = "https://chatbot-backend.mbbscare.in/"
    static let nursingBaseURL = "https://nurse-coach.mbbscare.in/"
    static let usmleStep1URL = "https://usmle-backend.mbbscare.in/"
    static let usmleStep2URL  = "https://usmle-2-backend.mbbscare.in/"
    
    static var byPassBaseURL = ""
    
    static var baseURL: String {
        if !byPassBaseURL.isEmpty {
            return byPassBaseURL
        } else {
            switch CourseEnvironment.shared.checkSelectedCourse() {
            case Courses.NEETPG.rawValue:
                return K.neetPGBaseURL
            case Courses.Nursing.rawValue:
                return K.nursingBaseURL
            case Courses.USMLESTEP1.rawValue:
                return K.usmleStep1URL
            case Courses.USMLESTEP2.rawValue:
                return K.usmleStep2URL
            default: return K.neetPGBaseURL
            }
        }
    }
    
    struct Content {
        static let appName = "Expense Tracker"
    }
  
    struct Font {
        static let sfUITextRegular = "SFUIText-Regular"
        static let sfUITextBold = "SFUIText-Bold"
        static let sfUITextBoldItalic = "SFUIText-BoldItalic"
        static let sfUITextHeavy = "SFUIText-Heavy"
        static let sfUITextHeavyItalic = "SFUIText-HeavyItalic"
        static let sFUITextLight = "SFUIText-Light"
        static let avenir = "avenir"
        
    }
    
    struct Image {
        static let scoreLogo = "ScoreLogo"
        static let googleLogo = "Google-logo"
        static let userKey = "user-key"
        static let videoDemo = "video_demo"
    }
    
    
}
