//
//  BannerAdView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/03/03.
//

import SwiftUI
import AppTrackingTransparency
import AdSupport

struct BannerAdView: View {
    
    @AppStorage(K.key.requestTrackingAuthorization) private var requestTrackingAuthorization: Bool = false
    
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
        .onAppear {
            if requestTrackingAuthorization {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                        ATTrackingManager.requestTrackingAuthorization { _ in }
                    }
                }
            }
        }
    }
}
