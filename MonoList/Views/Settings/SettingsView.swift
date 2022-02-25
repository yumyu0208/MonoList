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
    
    var body: some View {
        NavigationView {
            List {
                
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
