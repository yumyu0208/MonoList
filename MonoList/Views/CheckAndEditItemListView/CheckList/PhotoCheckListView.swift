//
//  PhotoCheckListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/24.
//

import SwiftUI

struct PhotoCheckListView: View {
    var items: FetchedResults<Item>
    var categories: FetchedResults<Category>
    var showAndHideUndoButtonAction: () -> Void
    var showImageViewerAction: (Image) -> Void
    var columns: [GridItem]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(items) { item in
                    PhotoCheckItemCell(item: item,
                                       showAndHideUndoButton: showAndHideUndoButtonAction,
                                       showImageViewerAction: showImageViewerAction)
                } //: VStack
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 20)
        } //: ScrollView
    }
}
