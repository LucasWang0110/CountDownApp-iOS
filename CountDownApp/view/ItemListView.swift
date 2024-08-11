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
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 20){
                    //total section
                    Section {
                        Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                            GridRow {
                                NavigationLink(destination: EmptyView()) {
                                    ListCard(icon: { CircleSymbolWithText(bgColor: .green, symbolNmae: "note", dispalyValue: 3) }, cardValue: 18, cardTitle: "Ongoing")
                                }
                                NavigationLink(destination: EmptyView()) {
                                    ListCard(icon: { CircleSymbol(bgColor: .red, symbolNmae: "clock.badge.xmark") }, cardValue: 12, cardTitle: "Overtime")
                                }
                            }
                            GridRow {
                                NavigationLink(destination: EmptyView()) {
                                    ListCard(icon: { CircleSymbol(bgColor: .blue, symbolNmae: "tray.fill") }, cardValue: 12, cardTitle: "Total")
                                }
                                NavigationLink(destination: EmptyView()) {
                                    ListCard(icon: { CircleSymbol(bgColor: .orange, symbolNmae: "flag.fill") }, cardValue: 12, cardTitle: "Flag")
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    
                    //item list section
                    Section(content: {
                        VStack {
                            ForEach(itemList.indices, id: \.self) { index in
                                let item = itemList[index]
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
                                
                                if index < itemList.count - 1 {
                                    Divider().padding(.trailing, -20).padding(.leading, 40)
                                }
                            }
                            
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }, header: {
                        Text(LocalizedStringKey("My List"))
                            .textCase(.none)
                            .font(.title2)
                            .bold()
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                    })
                    .sheet(isPresented: $displayListInfoSheet, content: {
                        ItemListEditView(itemList: $currentList)
                    })
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
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
