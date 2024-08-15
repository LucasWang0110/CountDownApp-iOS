//
//  DaysView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/6.
//

import SwiftUI
import EventKit

struct LifeView: View {
    
    @State private var searchText = ""
    @State private var selectedEvent: EKEvent?
    @State private var showEventEditViewController = false
    @State private var store = EKEventStore()
    
    @State private var showNewLifeSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                
                Section (content: {
                    ZStack {
                        row()
                        NavigationLink(destination: { LifeInfoView() }, label: { EmptyView() }).opacity(0)
                    }
                }, header: {
                    Text("Life Expectancy").SectionHeaderStyle()
                })
                
                Section(content: {
                    ForEach(1..<5) { item in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Memory someday")
                            HStack(alignment: .firstTextBaseline) {
                                Text("\(Date().formatted(date: .numeric, time: .omitted))")
                                Spacer()
                                Text("360").font(.title3).bold().foregroundStyle(.blue)
                                Text("past")
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                }, header: {
                    Text("Memory Days").SectionHeaderStyle()
                })
                
                Section(content: {
                    ForEach(1..<3) { item in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Event title")
                            HStack(alignment: .firstTextBaseline) {
                                Text("\(Date().formatted(date: .numeric, time: .omitted))")
                                Spacer()
                                Text("360").font(.title3).bold().foregroundStyle(.green)
                                Text("left")
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                }, header: {
                    Text("Upcoming Event").SectionHeaderStyle()
                })
                
            }
            .navigationTitle(Text("My Days"))
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(content: {
                        Button("Life Expectancy", systemImage: "heart", action: { showNewLifeSheet.toggle() })
                        Button("Memory day", systemImage: "calendar", action: {})
                        Button("Event", systemImage: "note.text", action: { showEventEditViewController.toggle() })
                    }, label: { Button("Add", systemImage: "plus", action: {}) })
                }
            }
            .sheet(isPresented: $showEventEditViewController, content: {
                EventEditViewController(event: $selectedEvent, eventStore: store)
            })
            .sheet(isPresented: $showNewLifeSheet, content: {
                AddLifeExpView()
            })
            
        }
    }
    
    func row() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Deadpool").font(.title2)
            Text("Birthday: \(Date().formatted(date: .numeric, time: .omitted))")
            HStack {
                Text("❤️: 20000 days")
                Spacer()
                Text("🎂: 200 days")
            }
        }
    }
}

#Preview {
    LifeView()
}
