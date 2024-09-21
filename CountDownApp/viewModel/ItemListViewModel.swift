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
    var copiedItemList: ItemList?
    var modelContext: ModelContext
    var openMode: OpenMode
    
    init(itemList: ItemList, modelContext: ModelContext, openMode: OpenMode) {
        if openMode == .new {
            self.itemList = itemList
        } else {
            self.itemList = itemList.copy() as! ItemList
            self.copiedItemList = itemList
        }
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
    
    private func saveModel() {
        modelContext.insert(itemList)
    }
    
    private func updateModel() {
        if let copy = copiedItemList {
            if itemList == copy {
                copy.title = itemList.title
                copy.themeColor = itemList.themeColor
                copy.icon = itemList.icon
                copy.updateTime = Date()
                try? modelContext.save()
            }
        }
        
    }
}
