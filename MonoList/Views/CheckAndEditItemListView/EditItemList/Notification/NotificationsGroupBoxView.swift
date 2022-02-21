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
    
    var isActive: Bool {
        itemList.notificationIsActive
    }
    
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
                    if isEditing {
                        Toggle("Notification",
                               isOn: $isExpanded
                                .animation(.easeOut(duration: 0.2))
                        )
                        .labelsHidden()
                    } else if isActive {
                        Toggle("Notification", isOn: $isExpanded.animation(.easeOut(duration: 0.2)))
                            .toggleStyle(.expand)
                            .labelsHidden()
                    }
                } //: HStack
                .contentShape(Rectangle())
                .onTapGesture {
                    if !isEditing, isActive {
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
                isExpanded = isActive
            } else {
                isExpanded = false
            }
        }
        .onChange(of: isExpanded) { isExpanded in
            guard isEditing else { return }
            itemList.notificationIsActive = isExpanded
            if isExpanded, !hasNotifications {
                addNotification(weekdays: K.weekday.allWeekdays)
            }
        }
        .onChange(of: editMode?.wrappedValue) { editMode in
            if isEditing, isActive {
                isExpanded = true
            }
        }
        .onChange(of: itemList.notificationIsActive) { isActive in
            withAnimation(.easeOut(duration: 0.2)) {
                isExpanded = isActive
            }
        }
    }
    
    @discardableResult
    func addNotification(weekdays: String, time: Date = Notification.defaultDate) -> Notification {
        let newNotification = itemList.createNewRepeatNotification(weekdays: weekdays, time: time, viewContext)
        saveData()
        return newNotification
    }
    
    private func deleteNotification(_ notification: Notification) {
        withAnimation {
            viewContext.delete(notification)
            saveData()
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
                .previewLayout(.fixed(width: 383, height: 260))
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
