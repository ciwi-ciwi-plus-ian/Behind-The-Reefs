//
//  Behind_The_ReefsApp.swift
//  Behind-The-Reefs
//
//  Created by Hana Azizah Nurhadi on 07/05/26.
//

import SwiftUI
import SwiftData

@main
struct Behind_The_ReefsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
