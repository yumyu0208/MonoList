//
//  CategoryHeaderView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/18.
//

import SwiftUI

struct CategoryHeaderView: View {
    
    var category: Category
    
    var body: some View {
        HStack {
            Label {
                Text(category.name)
                    .font(.headline)
            } icon: {
                Image(systemName: category.image ?? "tag")
            }
            .padding(.leading, 2)
            Spacer()
        } //: HStack
    }
}
