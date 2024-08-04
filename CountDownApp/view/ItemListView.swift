//
//  ItemListView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/3.
//

import SwiftUI

import SwiftUI
import SwiftData

struct ItemListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    
    @Query private var itemList: [ItemList]
    @Query private var items: [Item]
    
    @State private var displayNewItemListSheet = false
    @State private var displayOpenItemListSheet = false
    
    @State private var currentList: ItemList = ItemList.sampleData
    @State private var displayListInfoSheet = false

    var body: some View {
        NavigationStack {
            List {
                
                //total section
                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 20)], spacing: 20) {
                        ListCard(icon: { CircleSymbolWithText(bgColor: .blue, symbolNmae: "note", dispalyValue: 3) }, cardValue: 18, cardTitle: "Today")
                        ListCard(icon: { CircleSymbol(bgColor: .green, symbolNmae: "calendar") }, cardValue: 12, cardTitle: "Plan")
                        ListCard(icon: { CircleSymbol(bgColor: .red, symbolNmae: "tray.fill") }, cardValue: 12, cardTitle: "Plan")
                        ListCard(icon: { CircleSymbol(bgColor: .orange, symbolNmae: "flag.fill") }, cardValue: 12, cardTitle: "Plan")
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                
                //item list section
                Section(content: {
                    ForEach(itemList) { item in
                        NavigationLink(destination: ItemListInfoView(itemList: item), label: {
                            ListRow(itemList: item)
                        })
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete", systemImage: "trash.fill", role: .destructive, action: {
                                deleteList(itemList: item)
                            })
                            Button(action: {
                                currentList = item
                                displayListInfoSheet.toggle()
                            }, label: {
                                Image(systemName: "info.circle.fill")
                            })
                        }
                    }
                }, header: {
                    Text(LocalizedStringKey("我的列表"))
                        .textCase(.none)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(colorScheme == .light ? .black : .white)
                })
                .sheet(isPresented: $displayListInfoSheet, content: {
                    ItemListEditView(itemList: $currentList)
                })
                
            }
            .listSectionSpacing(10)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New List", systemImage: "rectangle.stack.badge.plus", action: {
                        displayNewItemListSheet.toggle()
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("More", systemImage: "ellipsis.circle", action: {})
                }
            }
            .sheet(isPresented: $displayNewItemListSheet) {
                NewItemListView()
            }
        }
    }
    
    func addList() {
        withAnimation {
            let itemList = ItemList(title: "Title", themeColor: "264653", icon: "folder.fill")
            modelContext.insert(itemList)
        }
    }
    
    func deleteList(itemList: ItemList) {
        withAnimation {
            modelContext.delete(itemList)
        }
    }
}

#Preview {
    ItemListView()
        .modelContainer(for: ItemList.self, inMemory: true)
}
