//
//  ReviewManager.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/03/03.
//

import UIKit
import StoreKit

class ReviewManager {
    
    static func presentReviewSheet() {
        let productURL: URL = URL(string: K.url.appStore)!
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "action", value: "write-review")]
        guard let writeReviewURL = components?.url else { return }
        UIApplication.shared.open(writeReviewURL)
    }
    
    static func presentReviewAlert() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
