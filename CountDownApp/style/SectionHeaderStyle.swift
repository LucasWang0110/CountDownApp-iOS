//
//  SectionHeaderStyle.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/12.
//

import Foundation
import SwiftUI

extension View {
    func SectionHeaderStyle() -> some View {
        self
            .font(.title2)
            .bold()
            .foregroundStyle(.black)
            .textCase(.none)
    }
}
