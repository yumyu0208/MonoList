//
//  EditIconView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/28.
//

import SwiftUI

struct EditIconView: View {
    @AppStorage(K.key.isPlusPlan) private var isPlusPlan: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State var manager = ListIconManager()
    @ObservedObject var itemList: ItemList
    @Binding var selectedIcon: String
    @Binding var image: String
    @Binding var color: String
    @Binding var primaryColor: String?
    @Binding var secondaryColor: String?
    @Binding var tertiaryColor: String?
    
    let saveAction: () -> Void
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 60, maximum: 200), spacing: 4), count: 5)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(manager.sections) { section in
                    Section(header: IconSectionHeaderView(title: section.name)) {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(section.icons) { icon in
                                let selected = (selectedIcon == icon.name)
                                ZStack {
                                    Image(systemName: "square")
                                        .padding(8)
                                        .foregroundColor(.clear)
                                    IconImageView(icon: icon)
                                }
                                .font(.system(.title, design: .rounded))
                                .background(selected ? Color(UIColor.systemGray5) : .clear)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .onTapGesture {
                                    if !selected {
                                        selectedIcon = icon.name
                                        image = icon.image
                                        color = icon.color
                                        primaryColor = icon.primaryColor
                                        secondaryColor = icon.secondaryColor
                                        tertiaryColor = icon.tertiaryColor
                                        saveAction()
                                    }
                                    dismiss()
                                }
                            } //: ForEach
                        } //: LazyVGrid
                        .inoperable(!isPlusPlan && !K.freeIconSections.contains(section.name), padding: .defaultListInsets) {
                            NavigationView {
                                PlusPlanView(feature: K.plusPlan.allIcons)
                            }
                        }
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


