//
//  TodoCell.swift
//  ToDoTask
//
//  Created by Ramesh Siddanavar on 08/03/22.
//

import SwiftUI

struct TodoCell: View {
    
    @ObservedObject var todo: Todo
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        return formatter
    }()
    
    var body: some View {
        HStack {
            Text("\(todo.dateCreated ?? Date(), formatter: dateFormatter)")
                .strikethrough(todo.isComplete, color: .black)
            Spacer()
            if !todo.isComplete && todo.isImportant{
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color.red).imageScale(.large)
            }
        }
    }
}
