//
//  Calendar+Utilities.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/28/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

extension Calendar {
    
    func daysUntil(event: Date) -> Int {
        let today = startOfDay(for: Date())
        let eventDate = startOfDay(for: event)
        let components = dateComponents([.day, .month], from: eventDate)
        let nextDate = nextDate(after: today, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)
        
        return dateComponents([.day], from: today, to: nextDate ?? today).day ?? 0
    }
}
