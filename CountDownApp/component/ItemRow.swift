//
//  ItemRow.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/4.
//

import SwiftUI

struct ItemRow: View {
    
    var item: Item
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
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
                VStack(spacing: 10) {
                    CustomProgressView(color: .green, progress: item.getProgress())
                        .frame(width: 40)
                        .overlay {
                            Text(String(format: "%.f%%", item.getProgress() * 100))
                                .font(.caption)
                        }
                    Text(item.endTime.formatted(date: .numeric, time: .omitted))
                        .font(.caption)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(.white)
            
            ProgressView(value: item.getProgress(), total: 1)
                .tint(.green)
                
        }
    }
}

#Preview {
    ItemRow(item: Item.sampleData)
}
