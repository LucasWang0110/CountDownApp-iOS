//
//  OverTimeItemRow.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/5.
//

import SwiftUI

struct OverTimeItemRow: View {
    
    var item: Item
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.title2)
                Text(item.remark)
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(.gray)
            }
            Spacer()
            VStack {
                Image(systemName: "clock.badge.xmark")
                    .foregroundStyle(.red)
                .font(.title2)
                
                Text("\(Calendar.current.dateComponents([.day], from: item.endTime, to: Date()).day!) days")
                    .font(.subheadline)
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    OverTimeItemRow(item: Item.sampleOverTimeData)
}
