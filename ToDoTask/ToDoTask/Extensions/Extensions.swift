//
//  Extensions.swift
//  ToDoTask
//
//  Created by Ramesh Siddanavar on 08/03/22.
//

import Foundation

// To get Number of days between two dates
extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}
