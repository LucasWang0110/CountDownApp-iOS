//
//  EventCenterViewModel.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/18.
//

import Foundation
import SwiftData

@Observable class EventObj: Hashable, Equatable {
    var event: MyEvent
    var isExist: Bool
    var isLoading: Bool = false
    
    init(event: MyEvent, isExist: Bool) {
        self.event = event
        self.isExist = isExist
    }
    
    static func == (lhs: EventObj, rhs: EventObj) -> Bool {
        return lhs.event == rhs.event
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(event)
    }
}

@Observable class EventCenterViewModel {
    var eventlist: [MyEvent]
    var modelContext: ModelContext
    var eventsFromDatabase: [EventObj] = []
    var selectedEvents: Set<EventObj> = []
    var searchText = ""
    
    init(eventlist: [MyEvent], modelContext: ModelContext) {
        self.eventlist = eventlist
        self.modelContext = modelContext
        fetchEvents()
    }
    
    var searchRestlt: [EventObj] {
        if self.searchText.isEmpty {
            return eventsFromDatabase
        } else {
            return eventsFromDatabase.filter { $0.event.title.contains(searchText) }
        }
    }
    
    func fetchEvents() {
        let count = self.eventsFromDatabase.count
        for i in 1..<11 {
            let offset = count + i
            let event = MyEvent(title: "Event: \(offset)", remark: "Remark for Event\(offset), maybe you can find more information about this event here.")
            let eventObj = EventObj(event: event, isExist: eventlist.contains { $0.title == event.title })
            self.eventsFromDatabase.append(eventObj)
        }
    }
    
    func addEventToLocal(_ eventObj: EventObj) {
        eventObj.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.modelContext.insert(eventObj.event)
            eventObj.isExist = true
            eventObj.isLoading = false
        }
    }
}
