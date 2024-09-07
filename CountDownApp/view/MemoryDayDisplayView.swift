//
//  MemoryDayDisplayView.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/4.
//

import SwiftUI

struct MemoryDayDisplayView: View {
    @Environment(\.modelContext) var modelContext
    var memoryDay: MemoryDayModel
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 0) {
                    Text(memoryDay.title)
                        .lineLimit(2)
                        .flexPadding()
                        .background(Color(hex: "F6EACB")!)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    
                    Text("\(memoryDay.daysUntilToday)")
                        .flexPadding()
                        .background(.white)
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                    
                    Divider()
                    
                    Text("Date: \(dateFormatter.string(from: memoryDay.date))")
                        .flexPadding()
                        .background(Color(uiColor: .systemGray5))
                }
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemGray6))
            .ignoresSafeArea()
            .navigationTitle(Text("Memory Day"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    NavigationLink(destination: MemoryDayInfoView(memoryDayViewModel: MemoryDayViewModel(memoryDay: memoryDay, modelContext: modelContext, openMode: .edit)), label: {
                        Text("Edit")
                    })
                })
            }
        }
    }
}

extension View {
    func flexPadding() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding()
    }
}

#Preview {
    MemoryDayDisplayView(memoryDay: MemoryDayModel(title: "Some day", date: .now))
}