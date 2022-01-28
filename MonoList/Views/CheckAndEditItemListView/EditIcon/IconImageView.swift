//
//  IconImageView.swift
//  IconMaker
//
//  Created by 竹田悠真 on 2022/01/27.
//

import SwiftUI

struct IconImageView: View {
    
    var icon: ListIcon
    
    var body: some View {
        if icon.primaryColor == nil {
            Image(systemName: icon.image)
                .foregroundStyle(Color(icon.color))
        } else {
            if icon.secondaryColor == nil {
                Image(systemName: icon.image)
                    .foregroundStyle(Color(icon.primaryColor!))
            } else {
                if icon.tertiaryColor == nil {
                    Image(systemName: icon.image)
                        .foregroundStyle(Color(icon.primaryColor!), Color(icon.secondaryColor!))
                } else {
                    Image(systemName: icon.image)
                        .foregroundStyle(Color(icon.primaryColor!), Color(icon.secondaryColor!), Color(icon.tertiaryColor!))
                }
            }
        }
    }
}

struct IconImageView_Previews: PreviewProvider {
    static var icon = ListIcon(name: "icon", image: "circle", color: "basic_blue")
    static var previews: some View {
        IconImageView(icon: icon)
            .previewLayout(.sizeThatFits)
    }
}
