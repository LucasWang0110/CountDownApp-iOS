//
//  SettingIconStyle.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/4.
//

import Foundation
import SwiftUI

struct SettingIconStyle: LabelStyle {
    var bgColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 7).fill(bgColor).frame(width: 30, height: 30)
                configuration.icon
                    .foregroundStyle(.white)
            }
            configuration.title
            Spacer()
        }
    }
}
