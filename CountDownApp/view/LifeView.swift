//
//  DaysView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/6.
//

import SwiftUI
import SwiftData
import EventKit

struct LifeView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var lifeList: [LifeModel]
    @Query private var memoryDayList: [MemoryDayModel]
    
    @State private var searchText = ""
    @State private var selectedEvent: EKEvent?
    @State private var showEventEditViewController = false
    @State private var store = EKEventStore()
    
    @State private var showNewLifeSheet = false
    @State private var showNewEventSheet = false
    
    //section expand state
    @State private var expandLifeSection = true
    @State private var expandMemorySection = true
    @State private var expandEventSection = true
    
    var body: some View {
        NavigationStack {
            List {
                
                Section (isExpanded: $expandLifeSection, content: {
                    ForEach(lifeList) { life in
                        ZStack {
                            row(life: life)
                            NavigationLink(destination: { LifeInfoView(lifeViewModel: LifeViewModel(life: life, lifeList: lifeList, modelContext: modelContext, openMode: .edit)) }, label: { EmptyView() }).opacity(0)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete", systemImage: "trash", role: .destructive, action: {
                                modelContext.delete(life)
                            })
                        }
                    }
                }, header: {
                    Text("Life Expectancy").SectionHeaderStyle()
                })
                
                Section(isExpanded: $expandMemorySection, content: {
                    ForEach(memoryDayList) { item in
                        ZStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(item.title).font(.system(.title2, design: .rounded, weight: .bold))
                                HStack(alignment: .firstTextBaseline) {
                                    Text("\(item.daysUntilToday)").font(.title3).bold().foregroundStyle(.blue)
                                    Spacer()
                                    Text("\(item.daysUntilSameDateNextYear)").font(.title3).bold().foregroundStyle(.green)
                                }
                                .foregroundStyle(.gray)
                            }
                            NavigationLink(destination: MemoryDayDisplayView(memoryDay: item), label: { EmptyView() }).opacity(0)
                        }
                    }
                }, header: {
                    Text("Memory Days").SectionHeaderStyle()
                })
                
                Section(isExpanded: $expandEventSection, content: {
                    ForEach(1..<3) { item in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Event title").font(.system(.title2, design: .rounded, weight: .bold))
                            HStack(alignment: .firstTextBaseline) {
                                Text("\(Date().formatted(date: .numeric, time: .omitted))")
                                Spacer()
                                Text("360").font(.title3).bold().foregroundStyle(.green)
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                }, header: {
                    Text("Upcoming Event").SectionHeaderStyle()
                })
                
            }
            .listStyle(.sidebar)
            .animation(.default, value: lifeList)
            .navigationTitle(Text("My Days"))
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(content: {
                        Button("Life Expectancy", systemImage: "heart", action: { showNewLifeSheet.toggle() })
                        NavigationLink(destination: MemoryDayInfoView(memoryDayViewModel: MemoryDayViewModel(memoryDay: MemoryDayModel(title: "", date: .now), modelContext: modelContext, openMode: .new)), label: { Label("Memory day", systemImage: "calendar") })
                        Button("Event", systemImage: "note.text", action: { showNewEventSheet.toggle() })
                    }, label: { Button("Add", systemImage: "plus", action: {}) })
                }
            }
            .sheet(isPresented: $showEventEditViewController, content: {
                EventEditViewController(event: $selectedEvent, eventStore: store)
            })
            .sheet(isPresented: $showNewLifeSheet, content: {
                LifeInfoView(lifeViewModel: LifeViewModel(life: LifeModel(title: "", birthday: Date()), lifeList: lifeList, modelContext: modelContext, openMode: .new))
            })
            .sheet(isPresented: $showNewEventSheet, content: {
                NewEventView(editEvent: false, event: Event.sampleData)
            })
            .onAppear {
                print(memoryDayList)
            }
            
        }
    }
    
    func row(life: LifeModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(life.title).font(.system(.title2, design: .rounded, weight: .bold))
            Text("\(life.birthday.formatted(date: .numeric, time: .omitted))").foregroundStyle(.gray)
            HStack {
                Text("\(life.remainingDays)").foregroundStyle(.red)
                Spacer()
                Text("\(life.daysUntilNextBirthday)").foregroundStyle(.green)
            }
            .font(.system(.title2, design: .rounded, weight: .bold))
        }
    }
}

#Preview {
    LifeView()
}
