//
//  PersistenceManager.swift
//  ToDoTask
//
//  Created by Ramesh Siddanavar on 08/03/22.
//

import Foundation
import CoreData

class PersistenceManager {
    lazy var managedObjectContext: NSManagedObjectContext = { self.persistentContainer.viewContext }()
    
    lazy var persistentContainer: NSPersistentContainer  = {
        let container = NSPersistentContainer(name: Constants.NSPersistentContainer)
        container.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
}
