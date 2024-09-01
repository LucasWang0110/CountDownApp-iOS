//
//  LifeModel.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/31.
//

import Foundation
import SwiftData

@Model class LifeModel: Identifiable {
    var id: String
    var title: String
    var birthday: Date
    
    var createTime: Date
    var updateTime: Date
    
    init(title: String, birthday: Date) {
        let now = Date()
        self.id = UUID().uuidString
        self.title = title
        self.birthday = birthday
        self.createTime = now
        self.updateTime = now
    }
}

let LIFE_EXPECTANCY = 20000

extension LifeModel {
    
    // days of your life
    var remainingDays: Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: self.birthday, to: now)
        let daysLived = components.day ?? 0
        return min(LIFE_EXPECTANCY - daysLived, LIFE_EXPECTANCY)
    }
    
    // days to next birthday
    var daysUntilNextBirthday: Int {
        let calendar = Calendar.current
        let now = Date()
        
        let currentYear = calendar.component(.year, from: now)
        
        var birthdayComponents = calendar.dateComponents([.month, .day], from: self.birthday)
        birthdayComponents.year = currentYear
        
        let birthdayThisYear = calendar.date(from: birthdayComponents)!
        
        if now <= birthdayThisYear {
            return calendar.dateComponents([.day], from: now, to: birthdayThisYear).day ?? 0
        } else {
            var nextBirthdayComponents = birthdayComponents
            nextBirthdayComponents.year = currentYear + 1
            let birthdayNextYear = calendar.date(from: nextBirthdayComponents)!
            return calendar.dateComponents([.day], from: now, to: birthdayNextYear).day ?? 0
        }
    }
}
