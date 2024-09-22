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
    var modelContext: ModelContext
    var openMode: OpenMode
    
    init(item: Item, modelContext: ModelContext, openMode: OpenMode) {
        self.item = item
        self.modelContext = modelContext
        self.openMode = openMode
    }
}
