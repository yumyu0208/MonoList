//
//  NotificationsGroupBoxView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/11.
//

import SwiftUI

struct NotificationsGroupBoxView: View {
    @Environment(\.editMode) var editMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var itemList: ItemList
    
    @State private var isExpanded: Bool = false
    
    var hasNotifications: Bool {
        itemList.hasNotifications
    }
    
    var isEditing: Bool {
        (editMode?.wrappedValue ?? .inactive) == .active
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label(title: {
                        HStack(spacing: 4) {
                            Text(isEditing || hasNotifications ? "Alarm" : "No Alarm")
                                .font(.system(.title3, design: .default))
                                .fontWeight(.bold)
                                .id(hasNotifications)
                        }
                    }, icon: {
                        Image(systemName: hasNotifications ? "bell" : "bell.slash")
                            .font(.system(.title2, design: .default).bold())
                            .foregroundStyle(.yellow)
                            .frame(minWidth: 32)
                    })
                    Spacer()
                    if isEditing {
                        Toggle("Notification",
                               isOn: $isExpanded
                                .animation(.easeOut(duration: 0.2))
                        )
                        .labelsHidden()
                    } else if hasNotifications {
                        Toggle("Notification", isOn: $isExpanded.animation(.easeOut(duration: 0.2)))
                            .toggleStyle(.expand)
                            .labelsHidden()
                    }
                } //: HStack
                .contentShape(Rectangle())
                .onTapGesture {
                    if !isEditing, hasNotifications {
                        withAnimation(.easeOut(duration: 0.2)) {
                            isExpanded.toggle()
                        }
                    }
                }
                if isExpanded {
                    NotificationListView(of: itemList)
                }
            } //: VStack
        } //: GroupBox
        .groupBoxStyle(.white)
        .onAppear {
            if isEditing {
                isExpanded = itemList.hasNotifications
            } else {
                isExpanded = false
            }
        }
        .onChange(of: isExpanded) { isExpanded in
            guard isEditing else { return }
            if isExpanded {
                if !hasNotifications {
                    addNotification(weekdays: K.weekday.allWeekdays)
                }
            } else {
                deleteAllNotification()
            }
        }
        .onChange(of: editMode?.wrappedValue) { editMode in
            if isEditing, hasNotifications {
                isExpanded = true
            }
        }
    }
    
    @discardableResult
    func addNotification(weekdays: String, time: Date = Notification.defaultDate) -> Notification {
        let newNotification = itemList.createNewNotification(weekdays: weekdays, time: time, viewContext)
        saveData()
        return newNotification
    }
    
    private func deleteNotification(_ notification: Notification) {
        withAnimation {
            viewContext.delete(notification)
            saveData()
        }
    }
    
    private func deleteAllNotification() {
        (itemList.notifications?.allObjects as? [Notification])?.forEach({ notification in
            deleteNotification(notification)
        })
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

struct NotificationsGroupBoxView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let context1 = PersistenceController.preview.container.viewContext
            let itemList1 = MonoListManager().fetchItemLists(context: context1)[0]
            NotificationsGroupBoxView(itemList: itemList1)
                .environment(\.managedObjectContext, context1)
                .environment(\.editMode, .constant(EditMode.active))
                .padding()
                .previewLayout(.fixed(width: 383, height: 200))
            let context2 = PersistenceController.preview.container.viewContext
            let itemList2 = MonoListManager().fetchItemLists(context: context2)[0]
            NotificationsGroupBoxView(itemList: itemList2)
                .environment(\.managedObjectContext, context2)
                .environment(\.editMode, .constant(EditMode.inactive))
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
