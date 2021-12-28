//
//  Sample.swift
//  MonoList
//
//  Created by 竹田悠真 on 2021/12/28.
//

import Foundation

struct Sample {
    static func createSamples() {
        let favoriteFolder = Folder.createNewFolder(name: "default_favorite", image: "star")
        let workList = favoriteFolder.addItemList(name: "Work", color: K.listColors.basic.blue, image: "briefcase")
        workList.addItem(name: "Laptop")
        workList.addItem(name: "Pen")
        workList.addItem(name: "Pocket Book")
        workList.addItem(name: "Documents")
        workList.addItem(name: "Watch")
        let shoppingList = favoriteFolder.addItemList(name: "Shopping", color: K.listColors.basic.yellow, image: "cart")
        shoppingList.addItem(name: "Laptop")
        shoppingList.addItem(name: "Pen")
        shoppingList.addItem(name: "Pocket Book")
        shoppingList.addItem(name: "Documents")
        shoppingList.addItem(name: "Watch")
        let collegeList = favoriteFolder.addItemList(name: "College", color: K.listColors.basic.green, image: "graduationcap")
        collegeList.addItem(name: "Laptop")
        collegeList.addItem(name: "Pen")
        collegeList.addItem(name: "Pocket Book")
        collegeList.addItem(name: "Documents")
        collegeList.addItem(name: "Watch")
        let listsFolder = Folder.createNewFolder(name: "default_lists", image: "checkmark.circle.fill")
        let driveList = listsFolder.addItemList(name: "Drive", color: K.listColors.basic.lightBlue, image: "car")
        driveList.addItem(name: "Laptop")
        driveList.addItem(name: "Pen")
        driveList.addItem(name: "Pocket Book")
        driveList.addItem(name: "Documents")
        driveList.addItem(name: "Watch")
        let campList = listsFolder.addItemList(name: "Camp", color: K.listColors.basic.orange, image: "flame")
        campList.addItem(name: "Laptop")
        campList.addItem(name: "Pen")
        campList.addItem(name: "Pocket Book")
        campList.addItem(name: "Documents")
        campList.addItem(name: "Watch")
        let fishingList = listsFolder.addItemList(name: "Fishing", color: K.listColors.basic.gray, image: "ferry")
        fishingList.addItem(name: "Laptop")
        fishingList.addItem(name: "Pen")
        fishingList.addItem(name: "Pocket Book")
        fishingList.addItem(name: "Documents")
        fishingList.addItem(name: "Watch")
        let sportsList = listsFolder.addItemList(name: "Sports", color: K.listColors.basic.purple, image: "sportscourt")
        sportsList.addItem(name: "Laptop")
        sportsList.addItem(name: "Pen")
        sportsList.addItem(name: "Pocket Book")
        sportsList.addItem(name: "Documents")
        sportsList.addItem(name: "Watch")
        let domesticTravelList = listsFolder.addItemList(name: "Domestic Travel", color: K.listColors.basic.pink, image: "suitcase")
        domesticTravelList.addItem(name: "Laptop")
        domesticTravelList.addItem(name: "Pen")
        domesticTravelList.addItem(name: "Pocket Book")
        domesticTravelList.addItem(name: "Documents")
        domesticTravelList.addItem(name: "Watch")
        let overseasTravelList = listsFolder.addItemList(name: "Overseas Travel", color: K.listColors.basic.red, image: "airplane")
        overseasTravelList.addItem(name: "Laptop")
        overseasTravelList.addItem(name: "Pen")
        overseasTravelList.addItem(name: "Pocket Book")
        overseasTravelList.addItem(name: "Documents")
        overseasTravelList.addItem(name: "Watch")
    }
}
