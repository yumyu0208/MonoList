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
                    Button {
                        let folders = manager.fetchFolders(context: viewContext)
                        MonoListData.saveBackupData(folders: folders)
                    } label: {
                        Label("Back Up", systemImage: "arrow.down.doc")
                    }
                }
                Section {
                    Button {
                        manager.deleteAllFolders(context: viewContext)
                        MonoListData.loadBackupData(context: viewContext)
                    } label: {
                        Label("Restore From Back Up", systemImage: "arrow.up.doc")
                    }
                }
                
                Section {
                    NavigationLink(destination: CategoriesView()) {
                        Label("Categories", systemImage: "tag")
                    }
                }
                
                Section {
                    Toggle(isOn: $isPlusPlan) {
                        Label("MONOLIST+", systemImage: "plus")
                    }
                }
            }
            .navigationTitle(Text("Settings"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    XButtonView {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
