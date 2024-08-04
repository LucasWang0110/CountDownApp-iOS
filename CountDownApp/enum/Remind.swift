//
//  Remind.swift
//  CountDown
//
//  Created by lucas on 2024/7/21.
//

import Foundation

enum Remind: String, Codable, CaseIterable, Identifiable {
    case none, oneDay, twoDay, oneWeek, twoWeek, oneMonth, threeMonth, sixMonth, custom
    var id: Self { self }
}
