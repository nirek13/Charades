//
//  CharadesApp.swift
//  Charades
//
//  Created by Nirek Shetty on 2025-07-26.
//

import SwiftUI

@main
struct CharadesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
