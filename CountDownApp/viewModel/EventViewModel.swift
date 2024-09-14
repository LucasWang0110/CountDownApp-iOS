//
//  EventViewModel.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/9.
//

import Foundation
import SwiftData

@Observable class EventViewModel {
    var event: MyEvent
    var eventLocation: EventLocation?
    var modelContext: ModelContext
    var openMode: OpenMode
    
    init(event: MyEvent, modelContext: ModelContext, openMode: OpenMode) {
        self.event = event
        self.modelContext = modelContext
        self.openMode = openMode
        if let location = event.location {
            self.eventLocation = location
        } else {
            self.eventLocation = nil
        }
    }
    
    func save() {
        if openMode == .new {
            saveModel()
        } else {
            updateModel()
        }
    }
    
    private func saveModel() {
        if let location = eventLocation {
            modelContext.insert(location)
            event.location = location
        }
        modelContext.insert(event)
    }
    
    private func updateModel() {
        try? modelContext.save()
    }
}
