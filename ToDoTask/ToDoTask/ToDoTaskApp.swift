//
//  ToDoTaskApp.swift
//  ToDoTask
//
//  Created by Ramesh Siddanavar on 08/03/22.
//

import SwiftUI

@main
struct ToDoTaskApp: App {
//    let persistenceController = PersistenceController.shared

    let moc = PersistenceManager().managedObjectContext
    
    var body: some Scene {
        WindowGroup {
            // Pass the Managed Object Context from the container into the Environment
            TodoListView()
                .environment(\.managedObjectContext, moc)
        }
    }
}
