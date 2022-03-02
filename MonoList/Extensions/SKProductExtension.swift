//
//  SKProductExtension.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/03/02.
//

import Foundation
import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
