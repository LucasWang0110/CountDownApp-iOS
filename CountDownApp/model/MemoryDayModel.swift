//
//  MemoryDayModel.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/6.
//

import Foundation
import SwiftData

@Model class MemoryDayModel: Identifiable, CustomStringConvertible {
    var id: String
    var title: String
    var date: Date
    var displayTime: Bool = false
    var remind: Remind
    var repeatInfo: RepeatEnum
    
    var createTime: Date
    var updateTime: Date
    
    init(title: String, date: Date, remind: Remind = .none, repeatInfo: RepeatEnum = .none) {
        let now = Date()
        self.id = UUID().uuidString
        self.title = title
        
        let calendar = Calendar.current
        self.date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date) ?? date
        self.remind = remind
        self.repeatInfo = repeatInfo
        self.createTime = now
        self.updateTime = now
    }
    
    var daysUntilToday: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let targetDate = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: targetDate, to: today)
        return components.day ?? 0
    }
    
    var daysUntilSameDateNextYear: Int {
        let calendar = Calendar.current
        let now = Date()
        
        let currentYear = calendar.component(.year, from: now)
        
        var dateComponents = calendar.dateComponents([.month, .day], from: self.date)
        dateComponents.year = currentYear
        
        let dayThisYear = calendar.date(from: dateComponents)!
        
        if now <= dayThisYear {
            return calendar.dateComponents([.day], from: now, to: dayThisYear).day ?? 0
        } else {
            var nextDayComponents = dateComponents
            nextDayComponents.year = currentYear + 1
            let dayNextYear = calendar.date(from: nextDayComponents)!
            return calendar.dateComponents([.day], from: now, to: dayNextYear).day ?? 0
        }
    }
    
    var description: String {
        return """
        MemoryDayModel:
        ID: \(id)
        Title: \(title)
        Date: \(date)
        Display Time: \(displayTime)
        Remind: \(remind)
        Repeat Info: \(repeatInfo)
        Days Until Date: \(daysUntilToday)
        Days Until Same Date Next Year: \(daysUntilSameDateNextYear)
        Created At: \(createTime)
        Updated At: \(updateTime)
        """
    }
}
