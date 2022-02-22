//
//  EditAlarmView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/13.
//

import SwiftUI

struct AlarmView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var editMode: EditMode = .active
    @ObservedObject var itemList: ItemList
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EditNotificationsGroupBoxView(itemList: itemList)
                    .environment(\.editMode, $editMode)
            }
            .padding()
        } //: ScrollView
        .navigationTitle("Alarm")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                XButtonView {
                    dismiss()
                }
            }
        }
    }
}

struct EditAlarmView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        NavigationView {
            AlarmView(itemList: itemList)
                .environment(\.managedObjectContext, context)
        }
    }
}
