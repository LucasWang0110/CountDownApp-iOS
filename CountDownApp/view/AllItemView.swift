//
//  AllItemView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/7.
//

import SwiftUI

struct AllItemView: View {
    
    var sectionType: SectionType
    var itemList: [ItemList]
    
    @State private var expandedSections: [Bool]
        
    init(sectionType: SectionType, itemList: [ItemList]) {
        self.sectionType = sectionType
        self.itemList = itemList
        _expandedSections = State(initialValue: Array(repeating: true, count: itemList.count))
    }
    
    var body: some View {
        List {
            ForEach(Array(itemList.enumerated()), id:\.offset) { index, item in
                if !item.items.isEmpty {
                    Section(isExpanded: $expandedSections[index], content: {
                        ForEach(item.items, id:\.id) { it in
                            itemRow(item: it)
                        }
                    }, header: {
                        Text(item.title)
                    })
                }
            }
        }
        .navigationTitle(LocalizedStringKey("All"))
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.sidebar)
    }
    
    func itemRow(item: Item) -> some View {
        VStack {
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
            }
            HStack {
                HStack {
                    Text(item.startTime.formatted(date: .numeric, time: item.allDay ? .omitted : .shortened))
                    VStack {
                        Divider()
                    }
                    .frame(width: 20)
                    Text(item.endTime.formatted(date: .numeric, time: item.allDay ? .omitted : .shortened))
                }
                Spacer()
                if item.isDone {
                    Image(systemName: "checkmark").foregroundStyle(.green)
                }
                if item.isInprogress() {
                    Text(String(format: "%.f%%", item.getProgress() * 100))
                }
                if item.isOverTime() {
                    Text("\(Calendar.current.dateComponents([.day], from: item.endTime, to: Date()).day!) days").foregroundStyle(.red)
                }
            }
            .font(.caption)
            .foregroundStyle(.gray)
        }
    }
}

#Preview {
    AllItemView(sectionType: .total, itemList: ItemList.sampleList)
}
