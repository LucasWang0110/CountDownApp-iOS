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
        VStack(alignment: .leading) {
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
                if item.flag {
                    Image(systemName: "flag.fill")
                        .foregroundStyle(.orange)
                }
                VStack {
                    Image(systemName: "clock.badge.xmark")
                        .foregroundStyle(.red)
                    .font(.title2)
                    
                    Text("\(Calendar.current.dateComponents([.day], from: item.endTime, to: Date()).day!) days")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }
            }
            HStack(spacing: 20) {
                Text("start: \(item.startTime.formatted(date: .numeric, time: .omitted))")
                    .foregroundStyle(.green)
                Text("end: \(item.endTime.formatted(date: .numeric, time: .omitted))")
                    .foregroundStyle(.red)
            }
            .font(.footnote)
        }
    }
}

#Preview {
    OverTimeItemRow(item: Item.sampleOverTimeData)
}
