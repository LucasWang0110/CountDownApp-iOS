//
//  Priority.swift
//  CountDown
//
//  Created by lucas on 2024/7/21.
//

import Foundation

enum Priority: String, Codable, Identifiable, CaseIterable {
    case none, high, mid, low
    var id: Self { self }
}
