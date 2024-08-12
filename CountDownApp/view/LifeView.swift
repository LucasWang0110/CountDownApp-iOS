//
//  DaysView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/6.
//

import SwiftUI

struct LifeView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                
                Section (content: {
                    ZStack {
                        row()
                        NavigationLink(destination: { LifeInfoView() }, label: { EmptyView() }).opacity(0)
                    }
                }, header: {
                    Text("Life Expectancy")
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
                    Text("Memory days")
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
                    Text("Upcoming event")
                })
                
            }
            .navigationTitle(Text("My Days"))
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(content: {
                        Button("Life Expectancy", systemImage: "heart", action: {})
                        Button("Memory day", systemImage: "calendar", action: {})
                        Button("Event", systemImage: "note.text", action: {})
                    }, label: { Button("Add", systemImage: "plus", action: {}) })
                }
            }
            
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
