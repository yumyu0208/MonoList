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
    
    @State var isEditingNewRepeatNotification = false
    @State var isEditingNewSpecificDateAndTimeNotification = false
    
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
                        Group {
                            if notification.isRepeat {
                                EditRepeatNotificationView(notification: notification, isNew: false)
                            } else {
                                EditSpecificDateAndTimeNotificationView(notification: notification, isNew: false)
                            }
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                if notification.isRepeat {
                                    Text(notification.timeString)
                                        .font(.headline)
                                    Text(notification.weekdaysString)
                                        .font(.subheadline)
                                } else {
                                    Text(notification.dateAndTimeString)
                                        .font(.headline)
                                    Text("Only Once")
                                        .font(.subheadline)
                                }
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
                    Menu {
                        Button {
                            withAnimation(.easeOut(duration: 0.2)) {
                                newNotification = itemList?.createNewRepeatNotification(weekdays: K.weekday.allWeekdays, time: Notification.defaultDate, viewContext)
                                saveData()
                            }
                            isEditingNewRepeatNotification = true
                        } label: {
                            Label("Repeat", systemImage: "arrow.triangle.2.circlepath")
                        } //: Button
                        Button {
                            withAnimation(.easeOut(duration: 0.2)) {
                                newNotification = itemList?.createNewSpecificDateAndTimeNotification(time: Notification.defaultDate, viewContext)
                                saveData()
                            }
                            isEditingNewSpecificDateAndTimeNotification = true
                        } label: {
                            Label("Only Once", systemImage: "calendar.badge.clock")
                        } //: Button
                    } label: {
                        Label("Add Alarm", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                    }
                }
            } //: VStack
            NavigationLink(isActive: $isEditingNewRepeatNotification) {
                if let newNotification = newNotification {
                    EditRepeatNotificationView(notification: newNotification, isNew: true)
                }
            } label: {
                EmptyView()
            }
            NavigationLink(isActive: $isEditingNewSpecificDateAndTimeNotification) {
                if let newNotification = newNotification {
                    EditSpecificDateAndTimeNotificationView(notification: newNotification, isNew: true)
                }
            } label: {
                EmptyView()
            }
        } //: ZStack
        .onAppear {
            deleteExpiredNotifications(in: notifications)
        }
    }
    
    private func saveData() {
        do {
            try viewContext.save()
            print("Saved")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteExpiredNotifications(in notifications: FetchedResults<Notification>) {
        let expiredNotifications = notifications.filter { !$0.isRepeat && $0.time <= Date() }
        expiredNotifications.forEach { viewContext.delete($0) }
        saveData()
        #if DEBUG
        print("Delete Expired Notifications")
        #endif
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
