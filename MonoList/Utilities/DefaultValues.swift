//
//  DefaultValues.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/26.
//

import Foundation

struct DefaultValues {
    
    static let userDefaults = UserDefaults.standard
    
    static var hideCompleted: Bool {
        userDefaults.bool(forKey: K.key.hideCompleted)
    }
    
    static var listForm: String {
        userDefaults.string(forKey: K.key.listForm) ?? K.listForm.list.name
    }
    
    static var unitLabel: String {
        userDefaults.string(forKey: K.key.unitLabel) ?? K.unitLabel.gram
    }
}
