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
    @State private var searchText = ""
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
                        }
                    }, header: {
                        Text("In Progress")
                            .font(.title2)
                            .textCase(.none)
                            .bold()
                            .listRowInsets(.init(top: 20, leading: 0, bottom: 20, trailing: 0))
                    })
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                
                if !itemList.items.filter({ $0.isOverTime() }).isEmpty {
                    Section(isExpanded: $expandOverTime, content: {
                        ForEach(itemList.items.filter({ $0.isOverTime() }), id:\.id) { item in
                            OverTimeItemRow(item: item)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
                                Button("Delete", systemImage: "trash", role: .destructive, action: {
                                    itemList.removeItem(item: item)
                                    modelContext.delete(item)
                                })
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
                }
                
                if !itemList.items.filter({ $0.isDone }).isEmpty {
                    Section(isExpanded: $expandDone, content: {
                        ForEach(itemList.items.filter({ $0.isDone }), id:\.id) { item in
                            DoneItemView(item: item)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
                                Button("Delete", systemImage: "trash", role: .destructive, action: {
                                    itemList.removeItem(item: item)
                                    modelContext.delete(item)
                                })
                            })
                        }
                    }, header: {
                        Text("Done")
                            .font(.title2)
                            .textCase(.none)
                            .bold()
                            .listRowInsets(.init(top: 20, leading: 0, bottom: 20, trailing: 0))
                    })
                }
                
            }
            .listStyle(.sidebar)
            .navigationTitle(itemList.title)
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
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
