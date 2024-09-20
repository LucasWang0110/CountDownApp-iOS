//
//  EventModel.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/20.
//

import Foundation
import SwiftData

@Model
class MyEvent: Identifiable, CustomStringConvertible {
    var id: String = UUID().uuidString
    var title: String
    @Relationship(deleteRule: .cascade) var location: EventLocation?
    var remark: String
    var allDay: Bool
    var startTime: Date
    var endTime: Date
    @Attribute(.externalStorage) var images: [Data] = []
    
    var createTime: Date
    var updateTime: Date
    
    init(title: String, location: EventLocation? = nil, remark: String, allDay: Bool = false, startTime: Date = Date()) {
        let now = Date()
        self.title = title
        self.location = location
        self.remark = remark
        self.allDay = allDay
        self.startTime = startTime
        self.endTime = Calendar.current.date(byAdding: .day, value: 1, to: startTime)!
        self.createTime = now
        self.updateTime = now
    }
    
    var daysToStart: Int {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.day], from: startTime, to: currentDate)
        return abs(components.day ?? 0)
    }
    
    var isUpcoming: Bool {
        return Date() < startTime
    }
    
    var isFinished: Bool {
        return Date() > endTime
    }
    
    var isOngoing: Bool {
        let currentDate = Date()
        return currentDate >= startTime && currentDate <= endTime
    }
    
    var description: String {
        return """
        Event:
        id: \(id)
        title: \(title)
        remark: \(remark)
        allDay: \(allDay)
        startTime: \(startTime)
        endTime: \(endTime)
        createTime: \(createTime)
        updateTime: \(updateTime)
        """
    }
}

extension MyEvent {
    static var sampleData = MyEvent(title: "1", location: EventLocation(title: "11", subtitle: "111", latitude: 0, longitude: 0), remark: "", allDay: false, startTime: Date())
}

@Model
class EventLocation: Identifiable, CustomStringConvertible {
    var id: String = UUID().uuidString
    var title: String
    var subtitle: String
    var latitude: Double
    var longitude: Double
    
    init(title: String, subtitle: String, latitude: Double, longitude: Double) {
        self.title = title
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var description: String {
        return """
        EventLocation:
        ID: \(id)
        Title: \(title)
        Subtitle: \(subtitle)
        Latitude: \(latitude)
        Longitude: \(longitude)
        """
    }
}
