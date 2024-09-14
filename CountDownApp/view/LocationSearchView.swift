//
//  SearchBarView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/18.
//

import SwiftUI
import MapKit

@Observable
class LocationSearchService: NSObject, MKLocalSearchCompleterDelegate {
    var searchResults: [EventLocation] = []
    var searchCompleter = MKLocalSearchCompleter()

    override init() {
        super.init()
        searchCompleter.delegate = self
    }
    
    func search(query: String) {
        searchCompleter.queryFragment = query
    }

    func getCoordinates(for completion: MKLocalSearchCompletion, completionHandler: @escaping (EventLocation?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let mapItem = response?.mapItems.first else {
                completionHandler(nil)
                return
            }
            
            let coordinate = mapItem.placemark.coordinate
            let location = EventLocation(
                title: mapItem.name ?? completion.title,
                subtitle: completion.subtitle,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            completionHandler(location)
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results.map { result in
            EventLocation(
                title: result.title,
                subtitle: result.subtitle,
                latitude: 0.0,
                longitude: 0.0
            )
        }
    }
}

struct LocationSearchView: View {
    @State var locationService = LocationSearchService()
    @Environment(\.dismiss) var dismiss
    @Binding var eventLocation: EventLocation?
    
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationStack {
            List(locationService.searchResults) { location in
                VStack(alignment: .leading) {
                    Text(location.title)
                    Text(location.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    if let result = locationService.searchCompleter.results.first(where: { $0.title == location.title }) {
                        locationService.getCoordinates(for: result) { detailedLocation in
                            if let location = detailedLocation {
                                eventLocation = location  // Assign to event.location
                                print(eventLocation!)
                                dismiss()
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(Text("Search Location"))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchQuery, placement: .navigationBarDrawer)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onChange(of: searchQuery) {
                locationService.search(query: searchQuery)
            }
        }
    }
}

#Preview {
//    @State var location = EventLocation(title: "", subtitle: "", latitude: 0, longitude: 0)
    @State var location: EventLocation? = nil
    return LocationSearchView(eventLocation: $location)
}
