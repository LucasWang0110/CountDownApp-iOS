//
//  ItemListViewModel.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/20.
//

import Foundation
import SwiftData

@Observable class ItemListViewModel {
    var itemList: ItemList
    var copiedItemList: ItemList
    var modelContext: ModelContext
    var openMode: OpenMode
    
    init(itemList: ItemList, modelContext: ModelContext, openMode: OpenMode) {
        self.itemList = openMode == .new ? itemList : itemList.copy() as! ItemList
        self.copiedItemList = itemList
        self.modelContext = modelContext
        self.openMode = openMode
    }
    
    func save() {
        if openMode == .new {
            saveModel()
        } else {
            updateModel()
        }
    }
    
    func somethingChanged() -> Bool {
        return itemList != copiedItemList
    }
    
    private func saveModel() {
        modelContext.insert(itemList)
    }
    
    private func updateModel() {
        copiedItemList.title = itemList.title
        copiedItemList.themeColor = itemList.themeColor
        copiedItemList.icon = itemList.icon
        copiedItemList.updateTime = Date()
        try? modelContext.save()
    }
}
