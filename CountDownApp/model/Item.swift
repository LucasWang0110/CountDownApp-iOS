//
//  Item.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/1.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable, NSCopying, Equatable {
    var id: String = UUID().uuidString
    var title: String
    var remark: String
    
    var allDay: Bool = false
    var startTime: Date
    var endTime: Date
    
    var remind: Remind
    var repeatInfo: RepeatEnum
    
    var flag: Bool = false
    var priority: Priority
    
    var isDone: Bool = false
    
    var createTime: Date = Date()
    var updateTime: Date = Date()
    
    init(title: String, remark: String, remind: Remind = .none, repeatInfo: RepeatEnum = .none, priority: Priority = .none) {
        let now = Date()
        self.title = title
        self.remark = remark
        self.remind = remind
        self.repeatInfo = repeatInfo
        self.priority = priority
        self.startTime = now
        self.endTime = Calendar.current.date(byAdding: .day, value: 1, to: now)!
    }
    
    init(title: String, remark: String, startTime: Date, endTime: Date, remind: Remind = .none, repeatInfo: RepeatEnum = .none, priority: Priority = .none) {
        self.title = title
        self.remark = remark
        self.remind = remind
        self.repeatInfo = repeatInfo
        self.priority = priority
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Item(title: self.title, remark: self.remark, startTime: self.startTime, endTime: self.endTime, remind: self.remind, repeatInfo: self.repeatInfo, priority: self.priority)
        copy.createTime = self.createTime
        return copy
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.title == rhs.title &&
        lhs.remark == rhs.remark &&
        lhs.allDay == rhs.allDay &&
        lhs.startTime == rhs.startTime &&
        lhs.endTime == rhs.endTime &&
        lhs.remind == rhs.remind && 
        lhs.repeatInfo == rhs.repeatInfo &&
        lhs.priority == rhs.priority
    }
    
    var isUpcoming: Bool {
        let now = Date()
        return !isDone && now < startTime
    }
    
    
    func getProgress() -> Double {
        let totalInterval = self.endTime.timeIntervalSince(self.startTime)
        let currentInterval = Date().timeIntervalSince(self.startTime)
        return min(max(currentInterval / totalInterval, 0), 1)
    }
    
    func isInprogress() -> Bool {
        let now = Date()
        return !isDone && now >= startTime && now < endTime
    }
    
    func isOverTime() -> Bool {
        !isDone && Date() > endTime
    }
}
