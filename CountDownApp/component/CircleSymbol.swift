//
//  CircleSymbol.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/3.
//

import SwiftUI

struct CircleSymbol: View {
    
    var bgColor: Color
    var symbolNmae: String
    
    var body: some View {
        Circle()
            .fill(bgColor)
            .overlay {
                Image(systemName: symbolNmae)
                    .foregroundStyle(.white)
                    .font(.system(size: 14))
                    .bold()
            }
            .frame(width: 30)
    }
}

struct CircleSymbolWithText: View {
    
    var bgColor: Color
    var symbolNmae: String
    var dispalyValue: Int
    
    var body: some View {
        CircleSymbol(bgColor: bgColor, symbolNmae: "note")
            .overlay {
                Text(String(dispalyValue))
                    .offset(y: 1)
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
            }
    }
}

#Preview {
//    CircleSymbol(bgColor: .orange, symbolNmae: "folder.fill")
//    CircleSymbol(bgColor: .orange, symbolNmae: "calendar")
//    CircleSymbol(bgColor: .orange, symbolNmae: "tray.fill")
//    CircleSymbol(bgColor: .orange, symbolNmae: "flag.fill")
    CircleSymbolWithText(bgColor: .blue, symbolNmae: "note", dispalyValue: 21)
}
