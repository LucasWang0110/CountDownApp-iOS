//
//  MemoryDayViewModel.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/8.
//

import Foundation
import SwiftData

@Observable class MemoryDayViewModel {
    var memoryDay: MemoryDayModel
    var modelContext: ModelContext
    var openMode: OpenMode
    
    init(memoryDay: MemoryDayModel, modelContext: ModelContext, openMode: OpenMode) {
        self.memoryDay = memoryDay
        self.modelContext = modelContext
        self.openMode = openMode
    }
    
    func save() {
        if memoryDay.displayTime {
            let calendar = Calendar.current
            memoryDay.date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: memoryDay.date)!
        }
        if openMode == .new {
            saveModel()
        } else {
            updateModel()
        }
    }
    
    private func saveModel() {
        modelContext.insert(memoryDay)
    }
    
    private func updateModel() {
        try? modelContext.save()
    }
}
