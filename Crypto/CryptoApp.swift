//
//  CryptoApp.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 07/05/25.
//

import SwiftUI

@main
struct CryptoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
