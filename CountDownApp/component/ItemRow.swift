//
//  ItemRow.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/4.
//

import SwiftUI

struct ItemRow: View {
    @Environment(\.modelContext) var modelContext
    
    var item: Item
    var itemList: ItemList
    
    @State private var showItemViewSheet = false
    
    var body: some View {
        VStack {
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
                    } else if item.isDone {
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(.green)
                            .font(.title2)
                    } else if item.isUpcoming {
                        Text("\(Calendar.current.dateComponents([.day], from: Date(), to: item.startTime).day!)")
                            .foregroundStyle(.blue)
                    } else if item.isInprogress() {
                        CustomProgressView(color: .green, progress: item.getProgress())
                            .frame(width: 40)
                            .overlay {
                                Image(systemName: "checkmark").foregroundStyle(.gray)
                            }
                    } else if item.isOverTime() {
                        Image(systemName: "clock.badge.xmark")
                            .foregroundStyle(.red)
                            .font(.title2)
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
                    if item.flag {
                        if item.isDone {
                            Image(systemName: "checkmark").foregroundStyle(.green)
                        }else if item.isInprogress() {
                            Text(String(format: "%.f%%", item.getProgress() * 100))
                        }else if item.isOverTime() {
                            Text("\(Calendar.current.dateComponents([.day], from: item.endTime, to: Date()).day!) days").foregroundStyle(.red)
                        }
                    }
                    
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            .padding([.horizontal, .top])
            .padding(.bottom, item.isInprogress() == true ? 0 : 10)
            
            if item.isInprogress() {
                ProgressView(value: item.getProgress(), total: 1).tint(.green)
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
            Button(item.isDone ? "Mark as Undone" : "Mark as Done", systemImage: item.isDone ? "xmark" : "checkmark", action: {
                item.isDone = !item.isDone
            })
            .tint(item.isDone ? Color.red : Color.green)
        })
        .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
            Button("Delete", systemImage: "trash", role: .destructive, action: {
                itemList.removeItem(item: item)
                modelContext.delete(item)
            })
        })
        .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
            Button("Flag", systemImage: item.flag ? "flag.slash.fill" : "flag.fill", action: { item.flag = !item.flag })
                .tint(.orange)
        })
        .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
            Button("Info", systemImage: "info.circle.fill", action: { showItemViewSheet.toggle() })
        })
        .sheet(isPresented: $showItemViewSheet, content: {
            ItemView(itemViewModel: ItemViewModel(item: item, itemList: itemList, modelContext: modelContext, openMode: .edit))
        })
    }
}

#Preview {
    ItemRow(item: Item(title: "", remark: ""), itemList: ItemList.sampleData)
}
