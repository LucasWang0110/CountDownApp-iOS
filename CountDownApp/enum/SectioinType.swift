//
//  SectioinType.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/28.
//

import Foundation

enum SectionType: String, CaseIterable, Hashable, Identifiable {
    var id: Self {
        return self
    }
    case total, ongoing, flag, overTime
}
