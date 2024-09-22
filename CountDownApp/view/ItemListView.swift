//
//  ItemListInfoView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/4.
//

import SwiftUI

struct ItemListView: View {
    @Environment(\.modelContext) private var modelContext
    
    var itemList: ItemList
    
    @State private var expandUpcomimg = true
    @State private var expandInprogress = true
    @State private var expandOverTime = true
    @State private var expandDone = true
    @State private var displayNewItemSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                if !itemList.items.filter({ $0.isUpcoming }).isEmpty {
                    Section(isExpanded: $expandUpcomimg, content: {
                        ForEach(itemList.items.filter({ $0.isUpcoming }), id:\.id) { item in
                            ItemRow(item: item, itemList: itemList)
                        }
                    }, header: {
                        Text("Up Coming")
                            .font(.title2)
                            .textCase(.none)
                            .bold()
                            .listRowInsets(.init(top: 20, leading: 0, bottom: 20, trailing: 0))
                    })
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                if !itemList.items.filter({ $0.isInprogress() }).isEmpty {
                    Section(isExpanded: $expandInprogress, content: {
                        ForEach(itemList.items.filter({ $0.isInprogress() }), id:\.id) { item in
                            ItemRow(item: item, itemList: itemList)
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
                            ItemRow(item: item, itemList: itemList)
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
                }
                
                if !itemList.items.filter({ $0.isDone }).isEmpty {
                    Section(isExpanded: $expandDone, content: {
                        ForEach(itemList.items.filter({ $0.isDone }), id:\.id) { item in
                            ItemRow(item: item, itemList: itemList)
                        }
                    }, header: {
                        Text("Done")
                            .font(.title2)
                            .textCase(.none)
                            .bold()
                            .listRowInsets(.init(top: 20, leading: 0, bottom: 20, trailing: 0))
                    })
                    .listRowInsets(EdgeInsets())
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
                        ItemView(itemViewModel: ItemViewModel(item: Item(title: "", remark: ""), itemList: itemList, modelContext: modelContext, openMode: .new))
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
    ItemListView(itemList: ItemList.sampleData)
}
