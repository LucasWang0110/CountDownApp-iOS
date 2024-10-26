//
//  ItemListView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/3.
//

import SwiftUI
import SwiftData

struct MyListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \ItemList.sortIndex, order: .forward) private var itemList: [ItemList]
    @Query private var items: [Item]
    
    @State private var searchText = ""
    @State private var displayNewItemListSheet = false
    @State private var displayOpenItemListSheet = false
    
    @State private var currentList: ItemList = ItemList.sampleData
    @State private var displayListInfoSheet = false
    
    @State private var selectedType: SectionType? = nil
    @State private var isNavigating = false
    
    @State private var editableItemList: [ItemList] = []
    
    var ongingCount: Int { items.filter{ $0.isInprogress() }.count }
    var overtimeCount: Int{ items.filter{ $0.isOverTime() }.count }
    var flageCount: Int{ items.filter{ $0.flag }.count }
    var dayOfTheMonth: Int {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: Date())
        return day
    }
    
    var filteredList: [ItemList] {
        itemList.filter { items in
            items.items.contains { item in
                item.title.contains(searchText)
            }
        }
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                //total section
                Section {
                    LazyVGrid(columns: columns) {
                        ListCard(icon: { CircleSymbolWithText(bgColor: .green, symbolNmae: "note", dispalyValue: dayOfTheMonth) }, cardValue: ongingCount, cardTitle: "Ongoing")
                            .onTapGesture{
                                path.append(SectionType.ongoing)
                            }
                        ListCard(icon: { CircleSymbol(bgColor: .red, symbolNmae: "clock.badge.xmark") }, cardValue: overtimeCount, cardTitle: "Overtime")
                            .onTapGesture{
                                path.append(SectionType.overTime)
                            }
                        ListCard(icon: { CircleSymbol(bgColor: .blue, symbolNmae: "tray.fill") }, cardValue: items.count, cardTitle: "Total")
                            .onTapGesture{
                                path.append(SectionType.total)
                            }
                        ListCard(icon: { CircleSymbol(bgColor: .orange, symbolNmae: "flag.fill") }, cardValue: flageCount, cardTitle: "Flag")
                            .onTapGesture{
                                path.append(SectionType.flag)
                            }
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
                    .onMove(perform: moveList)
                    
                }, header: {
                    Text(LocalizedStringKey("My List"))
                        .textCase(.none)
                })
            
            }
            .navigationDestination(for: SectionType.self) { type in
                AllItemView(sectionType: type, itemList: itemList)
            }
            .background(Color(uiColor: .secondarySystemBackground))
            .searchable(text: $searchText)
            .searchSuggestions {
                ForEach(filteredList) { list in
                    Section(content: {
                        ForEach(list.items, id:\.id) { it in
                            SectionRow(item: it)
                        }
                    }, header: { Text(list.title).textCase(.none) })
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New List", systemImage: "rectangle.stack.badge.plus", action: {
                        displayNewItemListSheet.toggle()
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .sheet(isPresented: $displayNewItemListSheet) {
                ItemListInfoView(itemListViewModel: ItemListViewModel(itemList: ItemList(title: "", themeColor: sampleColors[0].toHex()!, icon: sampleSymbols[0], sortIndex: itemList.count), modelContext: modelContext, openMode: .new))
            }
            .sheet(isPresented: $displayListInfoSheet, content: {
                ItemListInfoView(itemListViewModel: ItemListViewModel(itemList: currentList, modelContext: modelContext, openMode: .edit))
            })
            .onAppear {
                editableItemList = itemList
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
    
    func moveList(from source: IndexSet, to destination: Int) {
        withAnimation {
            editableItemList.move(fromOffsets: source, toOffset: destination)
            for (index, item) in editableItemList.enumerated() {
                item.sortIndex = index
            }
        }
    }
}

#Preview {
    MyListView()
        .modelContainer(for: ItemList.self, inMemory: true)
}
