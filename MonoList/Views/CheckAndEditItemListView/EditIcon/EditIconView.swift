//
//  EditIconView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/28.
//

import SwiftUI

struct EditIconView: View {
    @Environment(\.dismiss) private var dismiss
    @State var manager = ListIconManager()
    private var columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 60, maximum: 200), spacing: 4), count: 5)
    //@Binding var selectedIcon: ListIcon
    var body: some View {
        NavigationView {
            List {
                ForEach(manager.sections) { section in
                    Section(header: IconSectionHeaderView(title: section.name)) {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(section.icons) { icon in
                                //let selected = (selectedIcon == icon)
                                ZStack {
                                    Image(systemName: "square")
                                        .padding(8)
                                        .foregroundColor(.clear)
                                    IconImageView(icon: icon)
                                }
                                .font(.system(.title, design: .rounded))
                                //.background(selected ? Color(UIColor.systemGray5) : .clear)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                //.onTapGesture {
                                //    if !selected {
                                //        self.selectedIcon = icon
                                //    }
                                //}
                            } //: ForEach
                        } //: LazyVGrid
                    } //: Section
                } //: ForEach
            } //: List
            .navigationTitle(Text("Select Icon"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    XButtonView {
                        dismiss()
                    }
                }
            }
        } //: NavigationView
        .onAppear {
            manager.loadData()
        }
    }
}

struct EditIconView_Previews: PreviewProvider {
    static var previews: some View {
        EditIconView()
    }
}
