//
//  UIColorExtension.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/20.
//

import UIKit

extension UIColor {

    func lighter(by rate: CGFloat = 0.30) -> UIColor? {
        return self.adjust(by: abs(rate) )
    }

    func darker(by rate: CGFloat = 0.30) -> UIColor? {
        return self.adjust(by: -1 * abs(rate) )
    }

    func adjust(by rate: CGFloat = 0.30) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + rate, 1.0),
                           green: min(green + rate, 1.0),
                           blue: min(blue + rate, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
