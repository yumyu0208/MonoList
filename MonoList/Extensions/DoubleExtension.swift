//
//  CGFloatExtension.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/21.
//

import UIKit

extension Double {
    var string: String {
        let roundedValue = (self*10000).rounded(.toNearestOrAwayFromZero)/10000
        var string = String(roundedValue)
        let last = string.suffix(2)
        if last == ".0" {
            if let range = string.range(of: ".0") {
                string.replaceSubrange(range, with: "")
            }
        }
        return string
    }
}
