//
//  MonoListData.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/07.
//

import Foundation
import CoreData

struct MonoListData: Codable {
    var folders: [FolderData]
    
    static var sampleArchiveURL: URL {
        Bundle.main.url(forResource:"MonoListSampleData", withExtension: "plist")!
    }
    
    static var backupArchiveURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("MonoListBackupData").appendingPathExtension("plist")
    }
    
    static func loadSampleData(context: NSManagedObjectContext) {
        do {
            let retrievedData = try Data(contentsOf: Self.sampleArchiveURL)
            let decodedData = try PropertyListDecoder().decode(MonoListData.self, from: retrievedData)
            decodedData.folders.forEach { folderData in
                folderData.createFolder(context: context)
            }
            print("Successed to load sample MonoListData.")
        } catch {
            fatalError("Failed to load sample MonoListData.")
        }
    }
    
    static func loadBackupData(context: NSManagedObjectContext) {
        do {
            let retrievedData = try Data(contentsOf: Self.backupArchiveURL)
            let decodedData = try PropertyListDecoder().decode(MonoListData.self, from: retrievedData)
            decodedData.folders.forEach { folderData in
                folderData.createFolder(context: context)
            }
            print("Successed to load MonoListData.")
        } catch {
            fatalError("Failed to load MonoListData.")
        }
    }
    
    static func saveBackupData(folders: [Folder]) {
        let folderDataArray: [FolderData] = folders.map { $0.data() }
        let monoListData = MonoListData(folders: folderDataArray)
        do {
            let codedRanking = try PropertyListEncoder().encode(monoListData)
            try codedRanking.write(to: backupArchiveURL, options: .noFileProtection)
            print("Saved MonoListData")
        } catch {
            print("Failed to save MonoListData.\nError \(error)")
        }
    }
}
