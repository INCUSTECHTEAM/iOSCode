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
    
    static let baseURL = "https://vongo.incusquiz.com/vongo/"
    
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
