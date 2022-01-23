//
//  ImageManager.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/23.
//

import Foundation

struct ImageManager {
    
    static func loadImageNames() -> [String: [String]]? {
        if let url = Bundle.main.url(forResource:"SystemImageList", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:url)
                let dictionary = try PropertyListSerialization.propertyList(from: data, format: nil) as! [String: [String]]
                return dictionary
            } catch {
                print(error)
            }
        }
        return nil
    }
}
