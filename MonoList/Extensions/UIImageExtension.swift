//
//  UIImageExtension.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/16.
//

import UIKit

extension UIImage {
    func smallImage(minValue: CGFloat) -> UIImage {
        let targetHeight = (size.height <= size.width) ? minValue : (size.height/size.width)*minValue
        let targetWidth = (size.height >= size.width) ? minValue : (size.width/size.height)*minValue
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }
}
