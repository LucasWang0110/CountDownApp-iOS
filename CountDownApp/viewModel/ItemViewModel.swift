//
//  ItemViewModel.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/21.
//

import Foundation
import SwiftData

@Observable class ItemViewModel {
    var item: Item
    var itemList: ItemList
    var modelContext: ModelContext
    var openMode: OpenMode
    
    init(item: Item, itemList: ItemList, modelContext: ModelContext, openMode: OpenMode) {
        self.item = item
        self.itemList = itemList
        self.modelContext = modelContext
        self.openMode = openMode
    }
    
    func save() {
        if openMode == .new {
            saveModel()
        }
    }
    
    func saveModel() {
        modelContext.insert(item)
        itemList.items.append(item)
        do {
            try modelContext.save()
            print("Item saved successfully.")
        } catch {
            print("Failed to save item: \(error)")
        }
    }
}
