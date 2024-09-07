//
//  RepeatEnum.swift
//  CountDown
//
//  Created by lucas on 2024/7/29.
//

import Foundation
enum RepeatEnum: String, Codable, CaseIterable, Identifiable {
    case none, everyHour, everyDay, everyWeek, everyFortnight, everyMonth, every3Month, every6Month, everyYear, custom
    var id: Self { self }
}
