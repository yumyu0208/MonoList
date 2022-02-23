//
//  NomalCheckListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/24.
//

import SwiftUI

struct NomalCheckListView: View {
    var items: FetchedResults<Item>
    var categories: FetchedResults<Category>
    var showAndHideUndoButtonAction: () -> Void
    var showImageViewerAction: (Image) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(items) { item in
                    CheckItemCell(item: item, showAndHideUndoButton: showAndHideUndoButtonAction, showImageViewerAction: showImageViewerAction)
                } //: VStack
            } //: VStack
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 20)
        } //: ScrollView
    }
}

