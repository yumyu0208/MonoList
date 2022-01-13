//
//  EditItemListDetailView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/11.
//

import SwiftUI

struct EditItemListDetailView: View {
    @AppStorage("SelectedItemDetailTab") private var selectedTab: String = Tab.alarm.rawValue
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var itemList: ItemList
    
    enum Tab: String, CaseIterable, Identifiable {
        case alarm = "Alarm"
        case weight = "Weight"
        case info = "Info"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Tab",
                   selection: $selectedTab.animation(.linear)) {
                ForEach([Tab.alarm, Tab.info]) { tab in
                    Text(tab.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            TabView(selection: $selectedTab.animation(.linear)) {
                EditAlarmView(itemList: itemList)
                    .tag(Tab.alarm.rawValue)
                //WeightView(itemList: itemList).tag(Tab.weight.rawValue)
                InfoView(itemList: itemList)
                    .tag(Tab.info.rawValue)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        } //: VStack
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: itemList.image)
                        .foregroundStyle(Color(itemList.color))
                    Text(itemList.name)
                }
                .font(.body.bold())
            } //: ToolBarItem
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(CircleButtonStyle(type: .cancel))
            } // :ToolBarItem
        }
        .background(
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea(.all, edges: .all)
        )
    }
    
    private func saveData() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct EditItemListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        NavigationView {
            EditItemListDetailView(itemList: itemList)
                .environment(\.managedObjectContext, context)
        }
    }
}
