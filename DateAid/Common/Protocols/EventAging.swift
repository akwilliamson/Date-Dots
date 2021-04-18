//
//  EventAging.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/16/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import Foundation

protocol EventAging {
    
    var date: Date { get }
    
    var numOfYears: String { get }
    var daysAway: String   { get }
    var dayOfYear: String  { get }
}

extension EventAging {
    
    /// The age
    var numOfYears: String {
        let calendar = Calendar.current
        let dateToday  = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day, .month], from: date)
        let nextEvent  = calendar.nextDate(after: dateToday, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)!
        let numOfYears = calendar.dateComponents([.year], from: date, to: nextEvent).year ?? 0
        
        return String(numOfYears)
    }
    
    var daysAway: String {
        let calendar = Calendar.current
        let dateToday  = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day, .month], from: date)
        let nextEvent  = calendar.nextDate(after: dateToday, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)!
        let numOfDays  = calendar.dateComponents([.day], from: dateToday, to: nextEvent).day ?? 0

        return String(numOfDays) + " days"
    }
    
    var dayOfYear: String {
        return date.formatted("MMM dd")
    }
}
