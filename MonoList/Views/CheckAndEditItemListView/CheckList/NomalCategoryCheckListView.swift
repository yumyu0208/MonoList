//
//  NomalCheckListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/17.
//

import SwiftUI

struct NomalCategoryCheckListView: View {
    
    var items: FetchedResults<Item>
    var categories: FetchedResults<Category>
    var showAndHideUndoButtonAction: () -> Void
    var showImageViewerAction: (Image) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                ForEach(categories) { category in
                    let itemsInThisCategory = items.filter { $0.category == category }
                    if !itemsInThisCategory.isEmpty {
                        VStack(spacing: 20) {
                            CategoryHeaderView(category: category)
                            VStack(spacing: 20) {
                                ForEach(itemsInThisCategory) { item in
                                    CheckItemCell(item: item, showAndHideUndoButton: showAndHideUndoButtonAction, showImageViewerAction: showImageViewerAction)
                                } //: VStack
                            } //: VStack
                        } //: VStack
                    }
                } //: ForEach
                let itemsInNoneCategory = items.filter { $0.category == nil }
                if !itemsInNoneCategory.isEmpty {
                    VStack(spacing: 20) {
                        CategoryHeaderView()
                        VStack(spacing: 20) {
                            ForEach(itemsInNoneCategory) { item in
                                CheckItemCell(item: item, showAndHideUndoButton: showAndHideUndoButtonAction, showImageViewerAction: showImageViewerAction)
                            } //: VStack
                        } //: VStack
                    } // VStack
                }
            } //: VStack
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 20)
        } //: ScrollView
    }
}


