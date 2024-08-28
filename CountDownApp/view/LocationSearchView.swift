//
//  SearchBarView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/18.
//

import SwiftUI

struct LocationSearchView: View {
    @Environment(\.dismiss) var dismiss
    
    var event: Event
    
    @State private var locationService = LocationService(completer: .init())
    @State private var search: String = ""
    @State private var searchResults: SearchResult?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(locationService.completions) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.title)
                            Text(item.subTitle).font(.caption).foregroundStyle(.gray)
                        }
                        Spacer()
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        didTapOnCompletion(item)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .onChange(of: search) {
                locationService.update(queryFragment: search)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .searchable(text: $search, placement: .navigationBarDrawer, prompt: Text("search location"))
            .navigationTitle(Text("Location"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button("Cancel", action: { dismiss() })
                })
            }
        }
    }
    
    private func didTapOnCompletion(_ completion: SearchCompletions) {
        Task {
            if let singleLocation = try? await locationService.search(with: "\(completion.title) \(completion.subTitle)").first {
                searchResults = singleLocation
                let location = EventLocation(title: completion.title, subtitle: completion.subTitle, url: completion.url?.absoluteString ?? nil, latitude: searchResults?.location.latitude ?? 0, longitude: searchResults?.location.longitude ?? 0)
                event.location = location
                print(location)
            }
        }
    }
}

#Preview {
    LocationSearchView(event: Event.sampleData)
}
