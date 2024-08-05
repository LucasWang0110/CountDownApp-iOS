//
//  ItemRow.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/4.
//

import SwiftUI

struct ItemRow: View {
    
    var item: Item
    @State private var progress: Double = 0
    
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
                    CustomProgressView(color: .green, progress: caculateProgress())
                        .frame(width: 40)
                        .overlay {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color(uiColor: .lightGray))
                                .bold()
                                .font(.title3)
                        }
                    Text(item.endTime.formatted(date: .numeric, time: .omitted))
                        .font(.caption)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(.white)
            
            ProgressView(value: progress, total: 1)
                .tint(.green)
                
        }
        .onAppear {
            progress = caculateProgress()
        }
    }
    
    func caculateProgress() -> Double {
        let totalInterval = item.endTime.timeIntervalSince(item.startTime)
        let currentInterval = Date().timeIntervalSince(item.startTime)
        return min(max(currentInterval / totalInterval, 0), 1)
    }
}

#Preview {
    ItemRow(item: Item.sampleData)
}
