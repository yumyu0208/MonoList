//
//  StringExtension.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/18.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
