//
//  IconSectionHeaderView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/28.
//

import SwiftUI

struct IconSectionHeaderView: View {
    var title: String
    var body: some View {
        Text(title.localized)
            .font(.headline)
            .foregroundColor(.primary)
    }
}

struct IconSectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        IconSectionHeaderView(title: "Title")
    }
}
