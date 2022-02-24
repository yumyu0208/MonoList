//
//  EdgeInsetsExtension.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/24.
//

import Foundation
import SwiftUI

extension EdgeInsets {
    static var defaultListInsets: EdgeInsets {
        return .init(top: 6, leading: 20, bottom: 6, trailing: 20)
    }
    static var zeroListInsets: EdgeInsets {
        return .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}
