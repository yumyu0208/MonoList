//
//  PhotoCheckListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/17.
//

import SwiftUI

struct PhotoCategoryCheckListView: View {
    var items: FetchedResults<Item>
    var categories: FetchedResults<Category>
    var showAndHideUndoButtonAction: () -> Void
    var showImageViewerAction: (Image) -> Void
    var columns: [GridItem]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                let itemsInNoneCategory = items.filter { $0.category == nil }
                if !itemsInNoneCategory.isEmpty {
                    Section {
                        ForEach(itemsInNoneCategory) { item in
                            PhotoCheckItemCell(item: item,
                                               showAndHideUndoButton: showAndHideUndoButtonAction,
                                               showImageViewerAction: showImageViewerAction)
                        } //: VStack
                    } //: Section
                }
                ForEach(categories) { category in
                    let itemsInThisCategory = items.filter { $0.category == category }
                    if !itemsInThisCategory.isEmpty {
                        Section(header: CategoryHeaderView(category: category).padding(.top, 8)) {
                            ForEach(itemsInThisCategory) { item in
                                PhotoCheckItemCell(item: item,
                                                   showAndHideUndoButton: showAndHideUndoButtonAction,
                                                   showImageViewerAction: showImageViewerAction)
                            } //: VStack
                        } //: Section
                    }
                } //: ForEach
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 20)
        } //: ScrollView
    }
}

