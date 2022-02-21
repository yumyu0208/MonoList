//
//  Environment.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/21.
//

import Foundation
import SwiftUI

struct DeeplinkKey: EnvironmentKey {
    static var defaultValue: Deeplinker.Deeplink? {
        return nil
    }
}

extension EnvironmentValues {
    var deeplink: Deeplinker.Deeplink? {
        get {
            self[DeeplinkKey.self]
        }
        set {
            self[DeeplinkKey.self] = newValue
        }
    }
}
