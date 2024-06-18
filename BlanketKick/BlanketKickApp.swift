//
//  BlanketKickApp.swift
//  BlanketKick
//
//  Created by chul on 6/18/24.
//

import SwiftUI

@main
struct BlanketKickApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            View_SignIN()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
