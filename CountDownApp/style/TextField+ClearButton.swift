//
//  TextField+ClearButton.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/18.
//

import Foundation
import SwiftUI

extension View {
    func withClearButton(for text: Binding<String>) -> some View {
        HStack {
            self
            Spacer()
            if !text.wrappedValue.isEmpty {
                Button(action: {
                    text.wrappedValue = ""
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .opacity(0.5)
                })
                .buttonStyle(.plain)
            }
        }
    }
}
