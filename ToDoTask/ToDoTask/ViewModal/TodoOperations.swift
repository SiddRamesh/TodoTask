//
//  TodoOperations.swift
//  ToDoTask
//
//  Created by Ramesh Siddanavar on 08/03/22.
//

import CoreData

// Businees Logic
struct TodoOperations {
    
    // Create an Obj
    public static func create(_ description: String,date:Date, using managedObjectContext: NSManagedObjectContext) {
        let newTodo = Todo(context: managedObjectContext)
        newTodo.id = UUID()
        newTodo.todoDescription = description
        newTodo.dateCreated = date
        newTodo.isComplete = false
        newTodo.isImportant = false
        
        saveChanges(using: managedObjectContext)
    }
    
    // Delete the sepcific Obj
    public static func delete(todo: Todo, using managedObjectContext: NSManagedObjectContext) {
        managedObjectContext.delete(todo)
        saveChanges(using: managedObjectContext)
    }
    
    // Edit the specific Obj
    public static func toggleIsImportant(_ todo: Todo?, using managedObjectContext: NSManagedObjectContext) {
        todo!.isImportant = !todo!.isImportant
        saveChanges(using: managedObjectContext)
    }
    
    // Check the specific obj
    public static func toggleIsComplete(_ todo: Todo?, using managedObjectContext: NSManagedObjectContext) {
        todo!.isComplete = !todo!.isComplete
        saveChanges(using: managedObjectContext)
    }
    
    // Save the sepcific Obj
    fileprivate static func saveChanges(using managedObjectContext: NSManagedObjectContext) {
        guard managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
