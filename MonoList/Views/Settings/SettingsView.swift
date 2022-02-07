//
//  SettingsView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/07.
//

import SwiftUI

struct SettingsView: View {
    
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
            }
            .navigationTitle(Text("Settings"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
