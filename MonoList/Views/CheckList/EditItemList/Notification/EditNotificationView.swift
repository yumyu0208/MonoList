//
//  EditNotificationView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/01/12.
//

import SwiftUI

struct EditNotificationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var notification: Notification
    private let weekdaySymbols: [String] = Notification.weekDaySymbols
    @State private var selectedWeekdays: String = ""
    @State private var selectedTime: Date = Date()
    
    let isNew: Bool
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(0 ..< weekdaySymbols.count, id: \.self) { index in
                        let isSelected = selectedWeekdays.contains(String(index))
                        Button {
                            withAnimation {
                                if isSelected {
                                    selectedWeekdays.removeAll { String($0) == String(index) }
                                } else {
                                    selectedWeekdays.append(String(index))
                                }
                            }
                        } label: {
                            HStack {
                                Text(weekdaySymbols[index])
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "checkmark")
                                    .font(.footnote.bold())
                                    .opacity(isSelected ? 1 : 0)
                                    .animation(.easeOut(duration: 0.2), value: isSelected)
                            }
                        }
                    }
                } header: {
                    Text("Every")
                        .font(.headline)
                        .foregroundColor(.primary)
                }.textCase(nil)
                Section {
                    DatePicker("Time", selection: $selectedTime, displayedComponents: [.hourAndMinute])
                }
            } //: List
            Button {
                notification.weekdays = Notification.sortedWeekdays(selectedWeekdays)
                notification.time = selectedTime
                saveData()
                dismiss()
            } label: {
                Label("Done", systemImage: "checkmark")
            }
            .buttonStyle(.capsule)
            .padding()
            .disabled(selectedWeekdays.isEmpty)
        } //: VStack
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(isNew ? Text("New Alarm") : Text("Edit Alarm"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    if isNew {
                        deleteNotification(notification)
                    }
                    dismiss()
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
                        Text("Delete Notification")
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                selectedWeekdays = notification.weekdays
                selectedTime = notification.time
            }
        }
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
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct EditNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let notification = MonoListManager().fetchNotifications(context: context)[0]
        Group {
            NavigationView {
                EditNotificationView(notification: notification, isNew: false)
                    .environment(\.managedObjectContext, context)
            }
        }
    }
}
