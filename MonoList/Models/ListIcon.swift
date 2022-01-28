//
//  Icon.swift
//  IconMaker
//
//  Created by 竹田悠真 on 2022/01/27.
//

import Foundation

struct ListIcon: Codable, Identifiable, Equatable {
    static func == (lhs: ListIcon, rhs: ListIcon) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID = UUID()
    var name: String
    var image: String
    var color: String
    var primaryColor: String? = nil
    var secondaryColor: String? = nil
    var tertiaryColor: String? = nil
    
}
