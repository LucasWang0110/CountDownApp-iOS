//
//  ListCard.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/3.
//

import SwiftUI

struct ListCard<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @ViewBuilder let icon: Content
    let cardValue: Int
    let cardTitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                icon
                Spacer()
                Text(String(cardValue))
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(colorScheme == .light ? .black : .white)
            }
            Text(LocalizedStringKey(cardTitle))
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.gray)
        }
        .padding(10)
        .background(Color(uiColor: colorScheme == .light ? .white : .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ListCard(icon: {
        CircleSymbol(bgColor: .blue, symbolNmae: "tray.fill")
    }, cardValue: 12, cardTitle: "Today")
}
