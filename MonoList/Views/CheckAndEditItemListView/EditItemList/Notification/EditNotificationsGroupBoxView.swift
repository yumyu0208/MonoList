//
//  NotificationsGroupBoxView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/11.
//

import SwiftUI

struct EditNotificationsGroupBoxView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var itemList: ItemList
    
    @State var isOn: Bool
    
    let center = UNUserNotificationCenter.current()
    
    var isActive: Bool {
        itemList.notificationIsActive
    }
    
    init(itemList: ItemList) {
        self.itemList = itemList
        self.isOn = itemList.notificationIsActive
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label(title: {
                        HStack(spacing: 4) {
                            Text(isActive ? "Alarm On" : "Alarm Off")
                                .font(.system(.title3, design: .default))
                                .fontWeight(.bold)
                                .id(isActive)
                        }
                    }, icon: {
                        Image(systemName: isActive ? "bell" : "bell.slash")
                            .font(.system(.title2, design: .default).bold())
                            .foregroundStyle(.tint)
                            .frame(minWidth: 32)
                    })
                    Spacer()
                    Toggle("Notification", isOn: $isOn.animation(.easeOut(duration: 0.2)))
                        .labelsHidden()
                } //: HStack
                if isActive {
                    NotificationListView(of: itemList)
                }
            } //: VStack
        } //: GroupBox
        .animation(.easeOut(duration: 0.2), value: isActive)
        .groupBoxStyle(.white)
        .onChange(of: isOn) { isOn in
            if isOn {
                center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    if granted {
                        withAnimation(.easeOut(duration: 0.2)) {
                            itemList.notificationIsActive = true
                        }
                        if let notifications = itemList.notifications?.allObjects as? [Notification] {
                            NotificationManager().setLocalNotifications(notifications)
                        }
                    } else {
                        self.isOn = false
                    }
                }
            } else {
                withAnimation(.easeOut(duration: 0.2)) {
                    itemList.notificationIsActive = false
                }
                if let notifications = itemList.notifications?.allObjects as? [Notification] {
                    NotificationManager().deletePendingNotificationRequests(notifications)
                }
            }
        }
    }
}

struct NotificationsGroupBoxView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let context1 = PersistenceController.preview.container.viewContext
            let itemList1 = MonoListManager().fetchItemLists(context: context1)[0]
            EditNotificationsGroupBoxView(itemList: itemList1)
                .environment(\.managedObjectContext, context1)
                .environment(\.editMode, .constant(EditMode.active))
                .padding()
                .previewLayout(.fixed(width: 383, height: 260))
            let context2 = PersistenceController.preview.container.viewContext
            let itemList2 = MonoListManager().fetchItemLists(context: context2)[0]
            EditNotificationsGroupBoxView(itemList: itemList2)
                .environment(\.managedObjectContext, context2)
                .environment(\.editMode, .constant(EditMode.inactive))
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
