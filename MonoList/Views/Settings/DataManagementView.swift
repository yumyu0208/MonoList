//
//  DataManagementView.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/25.
//

import SwiftUI

struct DataManagementView: View {
    
    @EnvironmentObject var manager: MonoListManager
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
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
                    MonoListData.loadData(from: .backup, viewContext)
                } label: {
                    Label("Restore From Back Up", systemImage: "arrow.up.doc")
                }
            }
            Section {
                Button {
                    manager.deleteAllFolders(context: viewContext)
                    MonoListData.loadData(from: .sample, viewContext)
                } label: {
                    Label("Restore From Sample", systemImage: "arrow.up.doc")
                }
            }
            Section {
                Button {
                    manager.deleteAllFolders(context: viewContext)
                    MonoListData.loadData(from: .catalog, viewContext)
                } label: {
                    Label("Restore From Catalog", systemImage: "arrow.up.doc")
                }
            }
        } //: List
        .navigationTitle(Text("Data Management"))
        .navigationBarTitleDisplayMode(.large)
    }
}

struct DataManagementView_Previews: PreviewProvider {
    static var previews: some View {
        DataManagementView()
    }
}
