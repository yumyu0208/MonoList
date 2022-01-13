//
//  NotificationListView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/11.
//

import SwiftUI

struct NotificationListView: View {
    @Environment(\.editMode) var editMode
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var notifications: FetchedResults<Notification>
    var itemList: ItemList?
    
    @State var isEditingNewNotification = false
    
    @State var newNotification: Notification?
    
    var isEditing: Bool {
        (editMode?.wrappedValue ?? .inactive) == .active
    }
    
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
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(notifications) { notification in
                    NavigationLink {
                        EditNotificationView(notification: notification, isNew: false)
                            .onDisappear {
                                if let itemList = itemList, !itemList.hasNotifications {
                                    withAnimation {
                                        itemList.notificationIsActive = false
                                        saveData()
                                    }
                                }
                            }
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
                                .opacity(isEditing ? 1 : 0)
                        } //: HStack
                        .padding(.horizontal, 6)
                        .padding(.vertical, 8)
                    }
                    .disabled(!isEditing)
                } //: ForEach
                if isEditing {
                    Button {
                        withAnimation(.easeOut(duration: 0.2)) {
                            newNotification = itemList?.createNewNotification(weekdays: K.weekday.allWeekdays, time: Notification.defaultDate, viewContext)
                        }
                        isEditingNewNotification = true
                    } label: {
                        Label("Add Alarm", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                    } //: Button
                }
            } //: VStack
            NavigationLink(isActive: $isEditingNewNotification) {
                if let newNotification = newNotification {
                    EditNotificationView(notification: newNotification, isNew: true)
                }
            } label: {
                EmptyView()
            }
        } //: ZStack
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
