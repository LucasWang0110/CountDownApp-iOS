//
//  ItemListView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/3.
//

import SwiftUI

import SwiftUI
import SwiftData

struct MyListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    
    @Query private var itemList: [ItemList]
    @Query private var items: [Item]
    
    @State private var searchText = ""
    @State private var displayNewItemListSheet = false
    @State private var displayOpenItemListSheet = false
    
    @State private var currentList: ItemList = ItemList.sampleData
    @State private var displayListInfoSheet = false
    
    @State private var selectedType: SectionType? = nil
    @State private var isNavigating = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            List {
                //total section
                Section {
                    LazyVGrid(columns: columns) {
                        Button(action: {
                            selectedType = .ongoing
                            isNavigating = true
                        }, label: {
                            ListCard(icon: { CircleSymbolWithText(bgColor: .green, symbolNmae: "note", dispalyValue: 3) }, cardValue: 18, cardTitle: "Ongoing")
                        })
                        Button(action: {
                            selectedType = .overTime
                            isNavigating = true
                        }, label: {
                            ListCard(icon: { CircleSymbol(bgColor: .red, symbolNmae: "clock.badge.xmark") }, cardValue: 12, cardTitle: "Overtime")
                        })
                        Button(action: {
                            selectedType = .total
                            isNavigating = true
                        }, label: {
                            ListCard(icon: { CircleSymbol(bgColor: .blue, symbolNmae: "tray.fill") }, cardValue: 12, cardTitle: "Total")
                        })
                        Button(action: {
                            selectedType = .flag
                            isNavigating = true
                        }, label: {
                            ListCard(icon: { CircleSymbol(bgColor: .orange, symbolNmae: "flag.fill") }, cardValue: 12, cardTitle: "Flag")
                        })
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                
                //item list section
                Section(content: {
                    ForEach(itemList, id: \.self) { item in
                        NavigationLink(destination: ItemListView(itemList: item), label: {
                            ListRow(itemList: item)
                                .badge(item.items.count)
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
                        })
                    }
                    
                }, header: {
                    Text(LocalizedStringKey("My List"))
                        .textCase(.none)
                })
                .sheet(isPresented: $displayListInfoSheet, content: {
                    ItemListInfoView(itemListViewModel: ItemListViewModel(itemList: currentList, modelContext: modelContext, openMode: .edit))
                })
            
            }
            .navigationDestination(isPresented: $isNavigating, destination: {
                if let selectedType = selectedType {
                    AllItemView(sectionType: selectedType, itemList: itemList)
                }
            })
            .background(Color(uiColor: .secondarySystemBackground))
            .navigationTitle(Text("My tasks"))
            .searchable(text: $searchText)
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
                ItemListInfoView(itemListViewModel: ItemListViewModel(itemList: ItemList(title: "", themeColor: sampleColors[0].toHex()!, icon: sampleSymbols[0]), modelContext: modelContext, openMode: .new))
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
    MyListView()
        .modelContainer(for: ItemList.self, inMemory: true)
}
