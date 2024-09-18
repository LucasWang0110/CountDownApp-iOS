//
//  CountDownAppApp.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/1.
//

import SwiftUI
import SwiftData

import FirebaseCore

@main
struct CountDownAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            ItemList.self,
            MyEvent.self,
            EventLocation.self,
            LifeModel.self,
            MemoryDayModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // register app delegate for Firebase setup
//  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
