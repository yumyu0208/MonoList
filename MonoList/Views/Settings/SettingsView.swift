//
//  SettingsView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/07.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage(K.key.isPlusPlan) private var isPlusPlan: Bool = false
    @EnvironmentObject var manager: MonoListManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State var isShowingPlusPlanView: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("")) {
                    Button {
                        isShowingPlusPlanView = true
                    } label: {
                        Label("MONOLIST PLUS", systemImage: "star")
                    }
                    .fullScreenCover(isPresented: $isShowingPlusPlanView) {
                        NavigationView {
                            PlusPlanView()
                        }
                    }
                }
                Section {
                    NavigationLink(destination: ListSettingView()) {
                        Label("List", systemImage: "checklist")
                    }
                }
                
//                Section {
//                    NavigationLink(destination: NotificationSettingView()) {
//                        Label("Notification", systemImage: "bell")
//                    }
//                }
                
                Section {
                    NavigationLink(destination: CategoriesView()) {
                        Label("Categories", systemImage: "tag")
                    }
                }
                
                Section {
                    NavigationLink(destination: DataManagementView()) {
                        Label("Data Management", systemImage: "sdcard")
                    }
                }
                
                Section {
                    Toggle(isOn: $isPlusPlan) {
                        Label("MONOLIST+", systemImage: "star")
                    }
                }
                
                Section {
                    Button {
                        // review
                    } label: {
                        Label("Write a Review", systemImage: "square.and.pencil")
                    }
                    Button {
                        // bug report
                    } label: {
                        Label("Bug Report", systemImage: "envelope")
                    }
                    Button {
                        // privacy policy
                    } label: {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                } footer: {
                    AppInformationView()
                        .padding(.top, 60)
                }
            } //: List
            .navigationTitle(Text("Settings"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    XButtonView {
                        dismiss()
                    }
                }
            }
        } //: NavigationView
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
