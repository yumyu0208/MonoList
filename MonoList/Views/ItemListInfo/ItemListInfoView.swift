//
//  ItemListInfoView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/10.
//

import SwiftUI

struct ItemListInfoView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var itemList: ItemList
    
    var body: some View {
        ScrollView {
            VStack {
                Label {
                    Text(itemList.name)
                } icon: {
                    Image(systemName: itemList.image)
                        .foregroundStyle(Color(itemList.color))
                }
                .font(.title.bold())
                .padding(.vertical)
                VStack(spacing: 20) {
                    InfoGroupBoxView(value: itemList.achievementCountString,
                                     title: "Achievements",
                                     image: "checkmark.seal.fill",
                                     color: .orange,
                                     canExpand: false)
                    InfoGroupBoxView(value: itemList.numberOfItemsString,
                                     title: "Items",
                                     image: "tray.2.fill",
                                     color: .mint,
                                     canExpand: itemList.hasItems) {
                        VStack(alignment: .leading, spacing: 4) {
                            if let items = itemList.items?.allObjects as? [Item] {
                                ForEach(items) { item in
                                    HStack(spacing: 0) {
                                        Circle()
                                            .frame(width: 4, height: 4)
                                            .padding(.trailing, 8)
                                        HStack(spacing: 2) {
                                            if item.isImportant {
                                                Image(systemName: "exclamationmark")
                                                    .foregroundStyle(.red)
                                            }
                                            Text(item.name)
                                        } //: HStack
                                    } //: HStack
                                } //: ForEach
                            }
                        } //: VStack
                        .padding(.leading, 4)
                    }
                    InfoGroupBoxView(title: itemList.hasNotifications ? "ON" : "OFF",
                                     image: itemList.hasNotifications ? "bell" : "bell.slash",
                                     color: .yellow,
                                     canExpand: itemList.hasNotifications)
                    InfoGroupBoxView(title: "Others",
                                     image: "info.circle",
                                     color: .gray, canExpand: true) {
                        VStack(spacing: 8) {
                            HStack {
                                Label("Created", systemImage: "wand.and.stars")
                                Spacer()
                                Text("2021/1/10 13:30")
                            }
                            HStack {
                                Label("Last Modified", systemImage: "clock.arrow.circlepath")
                                Spacer()
                                Text("Today")
                            }
                        } //: VStack
                        .padding(.leading, 4)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(Text("Info"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(CircleButton(type: .cancel))
            }
        }
    }
}

struct ItemListInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        NavigationView {
            ItemListInfoView(itemList: itemList)
                .environment(\.managedObjectContext, context)
        }
    }
}
