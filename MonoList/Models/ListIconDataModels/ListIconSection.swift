//
//  ListIconSection.swift
//  IconMaker
//
//  Created by 竹田悠真 on 2022/01/27.
//

import SwiftUI

struct ListIconSection: Codable, Identifiable, Equatable {
    static func == (lhs: ListIconSection, rhs: ListIconSection) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID = UUID()
    var name: String
    var icons: [ListIcon] = []
}
