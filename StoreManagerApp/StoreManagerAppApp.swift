//
//  StoreManagerAppApp.swift
//  StoreManagerApp
//
//  Created by SoRyong on 6/17/25.
//

import SwiftUI

@main
struct StoreManagerAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
