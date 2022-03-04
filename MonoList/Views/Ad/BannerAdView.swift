//
//  BannerAdView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/03/03.
//

import SwiftUI

import SwiftUI

struct BannerAdView: View {
    
    let adUnit: AdUnit
    let adFormat: AdFormat
    @State var adStatus: AdStatus = .loading
    
    var showPlusPlanAd: Bool {
        let randomInt = Int.random(in: 1...20)
        return randomInt <= 1
    }
    
    var body: some View {
        HStack {
            if adStatus == .failure || showPlusPlanAd {
                PlusPlanAdView()
            } else {
                BannerViewController(adUnitID: adUnit.unitID, adSize: adFormat.adSize, adStatus: $adStatus)
                    .frame(width: adFormat.size.width, height: adFormat.size.height)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
