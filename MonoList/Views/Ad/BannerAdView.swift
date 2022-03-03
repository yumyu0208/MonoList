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
    
    var body: some View {
        HStack {
            if adStatus != .failure {
                BannerViewController(adUnitID: adUnit.unitID, adSize: adFormat.adSize, adStatus: $adStatus)
                    .frame(width: adFormat.size.width, height: adFormat.size.height)
            } else if adStatus == .failure {
                PlusPlanAdView()
            }
        }
        .frame(maxWidth: .infinity)
    }
}
