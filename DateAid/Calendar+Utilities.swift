//
//  Calendar+Utilities.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/28/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

extension Calendar {
    
    func days(from date1: Date, to date2: Date) -> Int {
        let start = startOfDay(for: date1)
        let end = startOfDay(for: date2)
        let components = dateComponents([.day, .month], from: end)
        let nextDate = nextDate(after: start, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)
        
        return dateComponents([.day], from: start, to: nextDate ?? end).day ?? 0
    }
}
