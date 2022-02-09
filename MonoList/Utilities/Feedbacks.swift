//
//  Feedbacks.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/08.
//

import UIKit

struct F {
    static let notification = UINotificationFeedbackGenerator()
    static let medium = UIImpactFeedbackGenerator(style: .medium)
    static let light = UIImpactFeedbackGenerator(style: .light)
    static let heavy = UIImpactFeedbackGenerator(style: .heavy)
}
