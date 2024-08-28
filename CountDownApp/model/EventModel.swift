//
//  EventModel.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/20.
//

import Foundation
import MapKit
import SwiftData

@Model
class Event: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    @Relationship(deleteRule: .cascade) var location: EventLocation?
    var remark: String
    var allDay: Bool
    var startTime: Date
    var endTime: Date
    
    init(title: String, location: EventLocation, remark: String, allDay: Bool, startTime: Date = Date()) {
        self.title = title
        self.location = location
        self.remark = remark
        self.allDay = allDay
        self.startTime = startTime
        self.endTime = Calendar.current.date(byAdding: .day, value: 1, to: startTime)!
    }
}

extension Event {
    static var sampleData = Event(title: "1", location: EventLocation(title: "11", subtitle: "111", latitude: 0, longitude: 0), remark: "", allDay: false, startTime: Date())
}

@Model
class EventLocation: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var subtitle: String
    var url: String?
    var latitude: Double
    var longitude: Double
    
    init(title: String, subtitle: String, url: String? = nil, latitude: Double, longitude: Double) {
        self.title = title
        self.subtitle = subtitle
        self.url = url
        self.latitude = latitude
        self.longitude = longitude
    }
}
