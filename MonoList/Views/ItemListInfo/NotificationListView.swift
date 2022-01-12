//
//  NotificationListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/11.
//

import SwiftUI

struct NotificationListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var notifications: FetchedResults<Notification>
    var itemList: ItemList?
    
    init(of itemList: ItemList) {
        self.itemList = itemList
        
        _notifications = FetchRequest(
            sortDescriptors: [
                SortDescriptor(\.creationDate, order: .forward)
            ],
            predicate: NSPredicate(format: "parentItemList == %@", itemList)
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(notifications) { notification in
                NavigationLink {
                    Text(notification.timeString)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(notification.timeString)
                                .font(.headline)
                            Text(notification.weekdaysString)
                                .font(.subheadline)
                        } //: VStack
                        .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .font(.body.bold())
                            .imageScale(.small)
                            .foregroundColor(Color(UIColor.systemGray2))
                    } //: HStack
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                }
            } //: ForEach
        } //: VStack
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let itemList = MonoListManager().fetchItemLists(context: context)[0]
        NotificationListView(of: itemList)
            .padding()
            .environment(\.managedObjectContext, context)
            .previewLayout(.fixed(width: 300, height: 160))
    }
}
