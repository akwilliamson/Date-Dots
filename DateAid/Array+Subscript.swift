//
//  Array+Subscript.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/1/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

extension Array {
    
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
    
    var middleIndex: Int {
        return (isEmpty ? startIndex : count - 1) / 2
    }
}

extension Array where Element == Event {
    
    func shiftSorted() -> [Event] {
        let sortedEvents = sorted { one, two in
            Date.CalendarDate(date: one.date) < Date.CalendarDate(date: two.date)
        }

        let now = Date.CalendarDate(date: Date())
        
        let shiftedEvents = sortedEvents.sorted { one, two in
            let oneDate = Date.CalendarDate(date: one.date)
            let twoDate = Date.CalendarDate(date: two.date)
            
            if oneDate >= now && twoDate < now {
                return oneDate > twoDate
            } else {
                return oneDate < twoDate
            }
        }
        
        return shiftedEvents
    }
}
