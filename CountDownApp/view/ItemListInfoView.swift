//
//  ItemListInfoView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/4.
//

import SwiftUI

struct ItemListInfoView: View {
    @Environment(\.modelContext) private var modelContext
    
    var itemList: ItemList
    
    @State private var expandInprogress = true
    @State private var expandOverTime = true
    @State private var expandDone = true
    @State private var displayNewItemSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                if !itemList.items.filter({ $0.isInprogress() }).isEmpty {
                    Section(isExpanded: $expandInprogress, content: {
                        ForEach(itemList.items.filter({ $0.isInprogress() }), id:\.id) { item in
                            ItemRow(item: item)
                                .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                                    Button("Mark as Done", systemImage: "checkmark", action: { item.isDone = true })
                                        .tint(Color.green)
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
                                    Button("Info", systemImage: "info.circle.fill", action: {  })
                                })
                        }
                    }, header: {
                        Text("In Progress")
                            .font(.title2)
                            .textCase(.none)
                            .bold()
                            .listRowInsets(.init(top: 20, leading: 0, bottom: 20, trailing: 0))
                    })
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                
                if !itemList.items.filter({ $0.isOverTime() }).isEmpty {
                    Section(isExpanded: $expandOverTime, content: {
                        ForEach(itemList.items.filter({ $0.isOverTime() }), id:\.id) { item in
                            ItemRow(item: item)
                            .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                                Button("Mark as Done", systemImage: "checkmark", action: { item.isDone = true })
                                    .tint(Color.green)
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
                                Button("Info", systemImage: "info.circle.fill", action: {  })
                            })
                        }
                    }, header: {
                        Text("Over Time")
                            .font(.title2)
                            .textCase(.none)
                            .bold()
                            .listRowInsets(.init(top: 20, leading: 0, bottom: 20, trailing: 0))
                    })
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                
                if !itemList.items.filter({ $0.isDone }).isEmpty {
                    Section(isExpanded: $expandDone, content: {
                        ForEach(itemList.items.filter({ $0.isDone }), id:\.id) { item in
                            ItemRow(item: item)
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
                                Button("Info", systemImage: "info.circle.fill", action: {  })
                            })
                        }
                    }, header: {
                        Text("Done")
                            .font(.title2)
                            .textCase(.none)
                            .bold()
                            .listRowInsets(.init(top: 20, leading: 0, bottom: 20, trailing: 0))
                    })
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                
            }
            .listStyle(.sidebar)
            .navigationTitle(itemList.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Item", systemImage: "note.text.badge.plus", action: {
                        displayNewItemSheet.toggle()
                    })
                    .sheet(isPresented: $displayNewItemSheet) {
                        NewItemView(itemList: itemList)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("More", systemImage: "ellipsis.circle", action: {})
                }
            }
        }
    }
}

#Preview {
    ItemListInfoView(itemList: ItemList.sampleData)
}
