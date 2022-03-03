//
//  AdFormat.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/03/03.
//

import Foundation

import Foundation
import GoogleMobileAds

enum AdFormat {
    
    case adaptiveBanner
    
    var adSize: GADAdSize {
        switch self {
        case .adaptiveBanner: return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
        }
    }
    
    var size: CGSize {
        adSize.size
    }
}
