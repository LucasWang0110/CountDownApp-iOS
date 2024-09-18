//
//  EventCenterView.swift
//  CountDownApp
//
//  Created by lucas on 2024/9/15.
//

import SwiftUI
import SwiftData

struct EventCenterView: View {
    @Environment(\.editMode) private var editMode
    
    @Bindable var eventCenterViewModel: EventCenterViewModel
    
    @State private var searchText = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            List(eventCenterViewModel.eventsFromDatabase, id:\.self, selection: $eventCenterViewModel.selectedEvents) { item in
                ZStack {
                    NavigationLink(destination: EventDetailView(event: item.event)) {
                        EmptyView()
                    }
                    .opacity(0)
                    eventRow(item)
                }
                
            }
            .listStyle(.plain)
            .navigationTitle(Text("Event Center"))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("search event"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    EditButton()
                })
                ToolbarItem(placement: .bottomBar, content: {
                    if editMode?.wrappedValue.isEditing == true {
                        Button("Add to list", action: {})
                    }
                })
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
    
    func eventRow(_ item: EventObj) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.event.title)
                HStack {
                    Text(item.event.startTime.formatted(date: .numeric, time: .shortened))
                    VStack{ Divider().frame(width: 20) }
                    Text(item.event.endTime.formatted(date: .numeric, time: .shortened))
                }
                .font(.subheadline)
                .foregroundStyle(.gray)
            }
            
            Spacer()
            
            if editMode?.wrappedValue.isEditing == false {
                Button(action: {
                    eventCenterViewModel.addEventToLocal(item)
                }, label: {
                    if item.isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: item.isExist ? "checkmark" : "plus")
                    }
                })
                .clipShape(Circle())
                .buttonStyle(.bordered)
            }
        }
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MyEvent.self, configurations: config)
    return EventCenterView(eventCenterViewModel: EventCenterViewModel(eventlist: [], modelContext: container.mainContext))
}
