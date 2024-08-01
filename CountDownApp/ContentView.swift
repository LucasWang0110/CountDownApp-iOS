//
//  ContentView.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/1.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
        Text("hello world")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
