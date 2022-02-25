//
//  MonoListData.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/07.
//

import Foundation
import CoreData

struct MonoListData: Codable {
    enum Source: String {
        case backup = "Backup"
        case sample = "Sample"
        case catalog = "Catalog"
    }
    
    
    var folders: [FolderData]
    
    private static func getArchiveURL(of source: Source) -> URL {
        switch source {
        case .backup:
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(K.data.backupFileName).appendingPathExtension("plist")
        case .sample:
            return Bundle.main.url(forResource: K.data.sampleFileName, withExtension: "plist")!
        case .catalog:
            return Bundle.main.url(forResource: K.data.catalogFileName, withExtension: "plist")!
        }
    }
    
    static func loadData(from source: Source, _ context: NSManagedObjectContext) {
        do {
            let retrievedData = try Data(contentsOf: getArchiveURL(of: source))
            let decodedData = try PropertyListDecoder().decode(MonoListData.self, from: retrievedData)
            decodedData.folders.forEach { folderData in
                folderData.createFolder(context: context)
            }
            saveData(context)
            print("Successed to load MonoListData from \(source.rawValue).")
        } catch {
            fatalError("Failed to load MonoListData.")
        }
    }
    
    static func saveBackupData(folders: [Folder]) {
        let folderDataArray: [FolderData] = folders.map { $0.data() }
        let monoListData = MonoListData(folders: folderDataArray)
        do {
            let codedRanking = try PropertyListEncoder().encode(monoListData)
            try codedRanking.write(to: getArchiveURL(of: .backup), options: .noFileProtection)
            print("Saved MonoListData")
        } catch {
            print("Failed to save MonoListData.\nError \(error)")
        }
    }
    
    private static func saveData(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Saved")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
