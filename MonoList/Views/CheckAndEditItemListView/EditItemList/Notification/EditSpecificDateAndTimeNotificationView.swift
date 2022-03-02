//
//  EditSpecificDateAndTimeNotificationView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/21.
//

import SwiftUI

struct EditSpecificDateAndTimeNotificationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var notification: Notification
    @State private var selectedDate: Date = Date()
    @State var isShowingCancelConfirmationAlert: Bool = false
    let isNew: Bool
    let manager = NotificationManager()
    
    var isEdited: Bool {
        selectedDate != notification.time
    }
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                Section {
                    DatePicker("Date".localized, selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                        .accentColor(Color(notification.parentItemList.color))
                }
            } //: List
            Button {
                notification.time = selectedDate
                saveData()
                if !isNew {
                    manager.deletePendingNotificationRequests([notification])
                }
                manager.setLocalNotifications([notification])
                dismiss()
            } label: {
                Label("Done", systemImage: "checkmark")
            }
            .buttonStyle(.capsule)
            .padding()
            .background(Color(UIColor.systemGroupedBackground))
        } //: VStack
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(isNew ? Text("New Alarm") : Text("Edit Alarm"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    if isNew || isEdited {
                        isShowingCancelConfirmationAlert = true
                    } else {
                        dismiss()
                    }
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .bottomBar) {
                if !isNew {
                    Button(role: .destructive) {
                        deleteNotification(notification)
                        dismiss()
                    } label: {
                        Text("Delete Alarm")
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .alert("BackWithoutSave.description", isPresented: $isShowingCancelConfirmationAlert) {
            Button(role: .destructive) {
                if isNew {
                    deleteNotification(notification)
                }
                dismiss()
            } label: {
                Text("Close Without Saving")
            }
            Button("Cancel", role: .cancel) {
                isShowingCancelConfirmationAlert = false
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.selectedDate = notification.time
            }
        }
    }
    private func deleteNotification(_ notification: Notification) {
        withAnimation {
            manager.deletePendingNotificationRequests([notification])
            viewContext.delete(notification)
            saveData()
        }
    }
    
    private func saveData() {
        do {
            try viewContext.save()
            #if DEBUG
            print("Saved")
            #endif
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct EditSpecificDateAndTimeNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let notification = MonoListManager().fetchNotifications(context: context)[0]
        Group {
            NavigationView {
                EditSpecificDateAndTimeNotificationView(notification: notification, isNew: false)
                    .environment(\.managedObjectContext, context)
            }
        }
    }
}
