//
//  ItemListInfoView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/4.
//

import SwiftUI

struct ItemListInfoView: View {
    
    var itemList: ItemList
    
    @State private var expandInprogress = true
    @State private var expandDone = true
    @State private var searchText = ""
    @State private var displayNewItemSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(isExpanded: $expandInprogress, content: {
                    ForEach(itemList.items, id:\.id) { item in
                        ItemRow(item: item)
                    }
                }, header: {
                    Text("In Progress")
                        .font(.title2)
                        .textCase(.none)
                        .bold()
                })
                .padding(.vertical, 10)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                
                Section(isExpanded: $expandDone, content: {
                    ForEach(1..<5, id:\.self) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("item name")
                                    .font(.title2)
                                Text("some remark")
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            Image(systemName: "checkmark.circle")
                                .foregroundStyle(.green)
                                .font(.title2)
                        }
                    }
                }, header: {
                    Text("Done")
                        .font(.title2)
                        .textCase(.none)
                        .bold()
                        .listRowInsets(.init(top: 20, leading: 0, bottom: 20, trailing: 0))
                })
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
