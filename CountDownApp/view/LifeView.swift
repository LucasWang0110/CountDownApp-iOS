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
    @Query private var eventlist: [MyEvent]
    @Query private var locations: [EventLocation]
    
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
    
    var filteredLifeList: [LifeModel] {
        guard !searchText.isEmpty else { return lifeList }
        return lifeList.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
    
    var filteredMemoryDayList: [MemoryDayModel] {
        guard !searchText.isEmpty else { return memoryDayList }
        return memoryDayList.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
    
    var filteredEventlist: [MyEvent] {
        guard !searchText.isEmpty else { return eventlist }
        return eventlist.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                
                Section (isExpanded: $expandLifeSection, content: {
                    ForEach(filteredLifeList) { life in
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
                    Text("Life Expectancy").textCase(.none)
                })
                
                Section(isExpanded: $expandMemorySection, content: {
                    ForEach(filteredMemoryDayList) { item in
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
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete", systemImage: "trash", role: .destructive, action: {
                                modelContext.delete(item)
                            })
                        }
                    }
                }, header: {
                    Text("Memory Day").textCase(.none)
                })
                
                Section(isExpanded: $expandEventSection, content: {
                    ForEach(filteredEventlist, id:\.self) { event in
                        ZStack {
                            eventRow(event: event)
                            NavigationLink(destination: EventInfoView(eventViewModel: EventViewModel(event: event, modelContext: modelContext, openMode: .edit)), label: { EmptyView() }).opacity(0)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            Button("Delete", systemImage: "trash", role: .destructive, action: {
                                modelContext.delete(event)
                            })
                        })
                    }
                }, header: {
                    Text("Event").textCase(.none)
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
                        
                        NavigationLink(destination: MemoryDayInfoView(memoryDayViewModel: MemoryDayViewModel(memoryDay: MemoryDayModel(title: "", date: .now), modelContext: modelContext, openMode: .new)), label: { Label("Memory day", systemImage: "calendar")
                        })
                        
                        NavigationLink(destination: EventInfoView(eventViewModel: EventViewModel(event: MyEvent(title: "", remark: ""), modelContext: modelContext, openMode: .new)), label: {
                            Label("Event", systemImage: "note.text")
                        })
                        NavigationLink(destination: EventCenterView(eventCenterViewModel: EventCenterViewModel(eventlist: eventlist, modelContext: modelContext)), label: {
                            Label("Event Center", systemImage: "square.3.layers.3d")
                        })
                    }, label: { Image(systemName: "plus") })
                }
            }
            .sheet(isPresented: $showEventEditViewController, content: {
                EventEditViewController(event: $selectedEvent, eventStore: store)
            })
            .sheet(isPresented: $showNewLifeSheet, content: {
                LifeInfoView(lifeViewModel: LifeViewModel(life: LifeModel(title: "", birthday: Date()), lifeList: lifeList, modelContext: modelContext, openMode: .new))
            })
            
        }
    }
    
    func row(life: LifeModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(life.title).font(.system(.title2, design: .rounded, weight: .bold))
            HStack {
                Text("\(life.remainingDays)").foregroundStyle(.red)
                Spacer()
                Text("\(life.daysUntilNextBirthday)").foregroundStyle(.green)
            }
            .font(.system(.title2, design: .rounded, weight: .bold))
        }
    }
    
    func eventRow(event: MyEvent) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(event.title).font(.system(.title2, design: .rounded, weight: .bold))
            HStack(alignment: .firstTextBaseline) {
                HStack {
                    Text(event.startTime.formatted(date: .numeric, time: event.allDay ? .omitted : .shortened))
                    VStack {
                        Divider()
                    }
                    .frame(width: 20)
                    Text(event.endTime.formatted(date: .numeric, time: event.allDay ? .omitted : .shortened))
                }
                .font(.caption)
                Spacer()
                if event.isUpcoming {
                    Text("\(event.daysToStart)").font(.title3).bold().foregroundStyle(.green)
                } else if event.isOngoing {
                    Image(systemName: "hourglass").foregroundStyle(.green)
                }
            }
            .foregroundStyle(.gray)
        }
        .strikethrough(event.isFinished ? true : false)
    }
}

#Preview {
    LifeView()
}
