//
//  ListIcons.swift
//  IconMaker
//
//  Created by 竹田悠真 on 2022/01/27.
//

import SwiftUI

struct ListIconManager: Codable {
    
    var sections: [ListIconSection] = []
    
    var archiveURL: URL {
        Bundle.main.url(forResource:"Icons", withExtension: "plist")!
    }
    
    mutating func loadData() {
        do {
            let retrievedData = try Data(contentsOf: archiveURL)
            let decodedData = try PropertyListDecoder().decode([ListIconSection].self, from: retrievedData)
            sections = decodedData
        } catch {
            fatalError("Failed to load Icon Data.")
        }
    }
}
