//
//  Utils.swift
//  barleybreak
//
//  Created by Dmitry Belyaev on 31/10/2019.
//  Copyright © 2019 Dmitry Belyaev. All rights reserved.
//

import UIKit

class Utils {
    
    private static let EXISTS: String = "exists"
    private static let MODE = "mode"
    private static let HIGHSCORE = "highScore"
    private static let PROGRESS = "progress"
    private static let SAVED_SCORE = "savedScore"
    private static let CURRENT_DESIGN = "currentDesign"
    
    static let designNames: [String] = ["design1", "design2", "design3",
                                        "design4", "design5", "design6"]
    
    static func initializeUserDefault() {
        UserDefaults.standard.set(true, forKey: EXISTS)
        UserDefaults.standard.set(4, forKey: MODE)
        UserDefaults.standard.set(0, forKey: "highScore3x3")
        UserDefaults.standard.set(0, forKey: "highScore4x4")
        UserDefaults.standard.set(0, forKey: "highScore5x5")
        UserDefaults.standard.set(0, forKey: "highScore6x6")
        UserDefaults.standard.set("", forKey: "progress3x3")
        UserDefaults.standard.set("", forKey: "progress4x4")
        UserDefaults.standard.set("", forKey: "progress5x5")
        UserDefaults.standard.set("", forKey: "progress6x6")
        UserDefaults.standard.set(0, forKey: "savedScore3x3")
        UserDefaults.standard.set(0, forKey: "savedScore4x4")
        UserDefaults.standard.set(0, forKey: "savedScore5x5")
        UserDefaults.standard.set(0, forKey: "savedScore6x6")
        UserDefaults.standard.set(designNames[0], forKey: CURRENT_DESIGN)
    }
    
    static func UserDefaultsExists() -> Bool {
        return UserDefaults.standard.object(forKey: EXISTS) != nil
    }
    
    static func setHighScore(size: String, value: Int) {
        UserDefaults.standard.set(value, forKey: "\(HIGHSCORE)\(size)")
    }
    
    static func getHighScore(size: String) -> Int {
        return UserDefaults.standard.integer(forKey: "\(HIGHSCORE)\(size)")
    }
    
    static func setMode(value: Int) {
        UserDefaults.standard.set(value, forKey: MODE)
    }
    
    static func getMode() -> Int {
        return UserDefaults.standard.integer(forKey: MODE)
    }
    
    static func setProgress(size: String, value: String) {
        UserDefaults.standard.set(value, forKey: "\(PROGRESS)\(size)")
    }
    
    static func getProgress(size: String) -> String {
        return UserDefaults.standard.string(forKey: "\(PROGRESS)\(size)") ?? ""
    }
    
    static func setSavedScore(size: String, value: Int) {
        UserDefaults.standard.set(value, forKey: "\(SAVED_SCORE)\(size)")
    }
    
    static func getSavedScore(size: String) -> Int {
        return UserDefaults.standard.integer(forKey: "\(SAVED_SCORE)\(size)")
    }
    
    static func setCurrentDesign(value: String) {
        UserDefaults.standard.set(value, forKey: CURRENT_DESIGN)
    }
    
    static func getCurrentDesign() -> String {
        return UserDefaults.standard.string(forKey: CURRENT_DESIGN) ?? designNames[0]
    }
 
}
