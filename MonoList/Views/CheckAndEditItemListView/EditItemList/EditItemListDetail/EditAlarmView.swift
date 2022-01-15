//
//  EditAlarmView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/13.
//

import SwiftUI

struct EditAlarmView: View {
    
    @State private var editMode: EditMode = .active
    @ObservedObject var itemList: ItemList
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                NotificationsGroupBoxView(itemList: itemList)
                    .environment(\.editMode, $editMode)
            }
            .padding()
        } //: ScrollView
    }
}

struct EditAlarmView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        EditAlarmView(itemList: itemList)
            .environment(\.managedObjectContext, context)
    }
}
