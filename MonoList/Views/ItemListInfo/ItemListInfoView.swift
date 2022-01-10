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
                    InfoGroupBoxView(title: "Achievements",
                                     image: "checkmark.seal.fill",
                                     color: .orange,
                                     value: "\(itemList.achievementCount)")
                    InfoGroupBoxView(title: "Items",
                                     image: "tray.2.fill",
                                     color: .mint,
                                     value: "\(itemList.items?.count ?? 0)") {
                        Text("Laptop, Bag, Mouse, Wallet, iPhone")
                            .padding(.leading, 4)
                    }
                    InfoGroupBoxView(title: "Alarm",
                                     image: itemList.hasNotifications ? "bell.badge" : "bell",
                                     color: .yellow,
                                     value: itemList.hasNotifications ? "\(itemList.notifications?.count ?? 0)" : "None", isActive: false)
                    InfoGroupBoxView(title: "Others",
                                     image: "info.circle",
                                     color: .gray) {
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
