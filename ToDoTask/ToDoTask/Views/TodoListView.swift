//
//  TodoListView.swift
//  ToDoTask
//
//  Created by Ramesh Siddanavar on 08/03/22.
//

import SwiftUI
import CoreData
struct TodoListView : View {
    
    // MARK: - Core Data
    static let dateSortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
    
    static let today = NSSortDescriptor(keyPath: \Todo.dateCreated, ascending: false)
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Todo.entity(),
                  sortDescriptors: [dateSortDescriptor],
                  predicate: NSPredicate(format: "isComplete == false")) var todos: FetchedResults<Todo>
    
    @FetchRequest(entity: Todo.entity(),
                  sortDescriptors: [dateSortDescriptor],
                  predicate: NSPredicate(format: "isComplete == true")) var completedTodos: FetchedResults<Todo>
    
    // MARK: - View State
    @State var selectedTodo: Todo? = nil
    @State var newTodo: String = ""
    @State var showingSheet = false
    
    var today: [Todo] {
           return todos.filter({Calendar.current.isDateInToday($0.dateCreated!)})
       }
    
    var tommoro: [Todo] {
           return todos.filter({Calendar.current.isDateInTomorrow($0.dateCreated!)})
       }
    
    var upcoming: [Todo] {
        return todos.filter({ Calendar(identifier: .gregorian).numberOfDaysBetween(date, and: $0.dateCreated!) > Constants.upcomingDay })
       }
    
    @State private var date = Date()
    
    var body: some View {
        
        NavigationView {
            List {
                // The various cell types could be extracted.
                // Today
                Section(header:
                            HStack {
                    Text(Constants.today)
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color.green).imageScale(.large)
                        .onTapGesture {
                            TodoOperations.create(self.newTodo,
                                                  date: Calendar.current.date(byAdding: .day, value: Constants.todayDay, to: date)!,
                                                  using: self.managedObjectContext)
                        }
                }// HStack
                ) {
                    ForEach(self.today, id: \.id) { todo in
                        Button(action: {
                            self.selectedTodo = todo
                            self.showingSheet = true
                        }) {
                                TodoCell(todo: todo)
                        }
                    }
                    .onDelete { (index) in
                        deleteTodo(indexSet: index, todo: self.today)
                    }
                }
                
                // Tommorrow
                Section(header:
                            HStack {
                    Text(Constants.tommorro)
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color.green).imageScale(.large)
                        .onTapGesture {
                            TodoOperations.create(self.newTodo,
                                                  date: Calendar.current.date(byAdding: .day, value: Constants.tommoroDay, to: date)!,
                                                  using: self.managedObjectContext)
                        }
                }// HStack
                ) {
                    ForEach(self.tommoro, id: \.id) { todo in
                        Button(action: {
                            self.selectedTodo = todo
                            self.showingSheet = true
                        }) {
                                TodoCell(todo: todo)
                        }
                    }
                    .onDelete { (index) in
                        deleteTodo(indexSet: index, todo: self.tommoro)
                    }
                }
                
                // Upcoming
                Section(header:
                            HStack {
                    Text(Constants.upcoming)
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color.green).imageScale(.large)
                        .onTapGesture {
                            TodoOperations.create(self.newTodo,
                                                  date: Calendar.current.date(byAdding: .day, value: Int.random(in: Constants.upcomingDay...Constants.maxDay), to: date)!,
                                                  using: self.managedObjectContext)
                        }
                }// HStack
                ) { //
                    ForEach(self.upcoming ,id: \.id) { todo in
                        Button(action: {
                            self.selectedTodo = todo
                            self.showingSheet = true
                        }) {
                                TodoCell(todo: todo)
                        }
                    }
                    .onDelete { (index) in
                        deleteTodo(indexSet: index, todo: self.upcoming)
                    }
                }
                
                // Completed
                Section(header:
                            Text(Constants.completed)
                ) {
                    ForEach(completedTodos, id: \.id) { completedTodo in
                        TodoCell(todo: completedTodo)
                    }
                    .onDelete(perform: deleteCompletedTodos(at:))
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text(Constants.appName))
            .navigationBarItems(trailing: EditButton())
        }
        .actionSheet(isPresented: $showingSheet, content: {
            ActionSheet(
                title: Text(Constants.actionSheetTitle),
                message: nil,
                buttons: [
                    ActionSheet.Button.default(Text((self.selectedTodo?.isImportant ?? false) ? "Unflag" : "Flag")) {
                            TodoOperations.toggleIsImportant(self.selectedTodo, using: self.managedObjectContext)
                            self.showingSheet = false
                    }, ActionSheet.Button.default(Text("Mark as \((self.selectedTodo?.isComplete ?? false) ? "Incomplete" : "Complete")")) {
                            TodoOperations.toggleIsComplete(self.selectedTodo, using: self.managedObjectContext)
                            self.showingSheet = false
                    }, ActionSheet.Button.cancel({
                        self.showingSheet = false
                    })
                ])
        }) //actionSheet
    }
    
    // Update the view
    func deleteTodo(indexSet: IndexSet, todo: [Todo]) {
        guard let firstIndex = indexSet.first else { return }
        TodoOperations.delete(todo: todo[firstIndex], using: self.managedObjectContext)
    }
    
    func deleteTodos(at indexSet: IndexSet) {
        indexSet.forEach { TodoOperations.delete(todo: todos[$0], using: self.managedObjectContext) }
    }
    
    func deleteCompletedTodos(at indexSet: IndexSet) {
        indexSet.forEach { TodoOperations.delete(todo: completedTodos[$0], using: self.managedObjectContext) }
    }
}

#if DEBUG
struct TodoListView_Previews : PreviewProvider {
    static var previews: some View {
        TodoListView()
            .environment(\.managedObjectContext, PersistenceManager().managedObjectContext)
    }
}
#endif
