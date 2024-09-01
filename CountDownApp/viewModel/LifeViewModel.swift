//
//  LifeViewModel.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/31.
//

import Foundation
import SwiftData

@Observable class LifeViewModel {
    
    var life: LifeModel
    var lifeList: [LifeModel]
    var modelContext: ModelContext
    var openMode: OpenMode
    
    init(life: LifeModel, lifeList: [LifeModel], modelContext: ModelContext, openMode: OpenMode) {
        self.life = life
        self.lifeList = lifeList
        self.modelContext = modelContext
        self.openMode = openMode
    }
    
    func saveModel() {
        modelContext.insert(life)
        lifeList.append(life)
    }
    
    func updateModel() {
        try? modelContext.save()
    }
    
    func cancel() {
        modelContext.undoManager?.undo()
    }
}
