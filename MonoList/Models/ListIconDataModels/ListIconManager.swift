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
    
    func randomCheckListIcon() -> ListIcon {
        return sections.first { $0.name == "List" }?.icons.filter { $0.image == "checklist" }.randomElement() ?? ListIcon(name: "CheckList Red", image: "checklist", color: K.colors.basic.red, primaryColor: K.colors.basic.red, secondaryColor: K.colors.basic.gray)
    }
}
