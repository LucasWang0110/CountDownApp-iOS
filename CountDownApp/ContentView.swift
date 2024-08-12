//
//  ContentView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/1.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            
            LifeView()
                .tabItem { Image(systemName: "person.2.crop.square.stack.fill") }
                .tag(0)
            
            ItemListView()
                .tabItem { Image(systemName: "checkmark.rectangle.stack") }
                .tag(1)
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: [ItemList.self, Item.self], inMemory: true)
}
