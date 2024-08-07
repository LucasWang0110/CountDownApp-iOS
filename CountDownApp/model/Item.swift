//
//  Item.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/1.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable {
    var id: String
    var title: String
    var remark: String
    
    var allDay: Bool
    var startTime: Date
    var endTime: Date
    
    var remind: Remind
    var repeatInfo: RepeatEnum
    
    var flag: Bool
    var priority: Priority
    var parentListId: String
    
    var isDone: Bool = false
    
    var createTime: Date
    var updateTime: Date
    
    init(title: String, remark: String, allDay: Bool, startTime: Date, endTime: Date, remind: Remind, repeatInfo: RepeatEnum, flag: Bool, priority: Priority, parentListId: String, isDone: Bool, createTime: Date, updateTime: Date) {
        self.id = UUID().uuidString
        self.title = title
        self.remark = remark
        self.allDay = allDay
        self.startTime = startTime
        self.endTime = endTime
        self.remind = remind
        self.repeatInfo = repeatInfo
        self.flag = flag
        self.priority = priority
        self.parentListId = parentListId
        self.isDone = isDone
        self.createTime = createTime
        self.updateTime = updateTime
    }
    
    func getProgress() -> Double {
        let totalInterval = self.endTime.timeIntervalSince(self.startTime)
        let currentInterval = Date().timeIntervalSince(self.startTime)
        return min(max(currentInterval / totalInterval, 0), 1)
    }
    
    static var sampleData = Item(title: "item title", remark: "item remark", allDay: true, startTime: Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 10, hour: 12, minute: 0, second: 0))!, endTime: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 21, hour: 12, minute: 0, second: 0))!, remind: Remind.none, repeatInfo: RepeatEnum.none, flag: true, priority: Priority.none, parentListId: "", isDone: false, createTime: Date(), updateTime: Date())
    
    static var sampleOverTimeData = Item(title: "item title", remark: "item remark", allDay: true, startTime: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 10, hour: 12, minute: 0, second: 0))!, endTime: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 1, hour: 12, minute: 0, second: 0))!, remind: Remind.none, repeatInfo: RepeatEnum.none, flag: true, priority: Priority.none, parentListId: "", isDone: false, createTime: Date(), updateTime: Date())
    
    static var sampleDoneData: Item = Item(title: "item title", remark: "item remark", allDay: true, startTime: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 10, hour: 12, minute: 0, second: 0))!, endTime: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 1, hour: 12, minute: 0, second: 0))!, remind: Remind.none, repeatInfo: RepeatEnum.none, flag: true, priority: Priority.none, parentListId: "", isDone: true, createTime: Date(), updateTime: Date())
    
    func isInprogress() -> Bool {
        let now = Date()
        return !isDone && now >= startTime && now < endTime
    }
    
    func isOverTime() -> Bool {
        !isDone && Date() > endTime
    }
}
