//
//  DateExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension Foundation.Date {
    
    static var today: Foundation.Date { return Foundation.Date() }
    
    init(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateStringFormatter.date(from: dateString)!
        
        self.init(timeInterval: 0, since: date)
    }
    
    var formattedForTitle: String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        
        return formatter.string(from: self)
    }
    
    var calendar: Calendar {
        return Calendar.current
    }
    
    var components: DateComponents {
        return calendar.dateComponents(in: TimeZone.current, from: self)
    }
    
    var year: Int? {
        return components.year
    }
    
    var month: Int? {
        return components.month
    }
    
    var day: Int? {
        return components.day
    }
    
    var ageTurning: Int? {
        return calendar.dateComponents([.year], from: self, to: nextOccurence).year
    }
    
    var daysUntil: Int? {
        let today = calendar.startOfDay(for: Foundation.Date())
        let comps = calendar.dateComponents([.day, .month], from: self)
        let next = calendar.nextDate(after: today, matching: comps, matchingPolicy: .nextTimePreservingSmallerComponents)!
        let diff = calendar.dateComponents([.day], from: today, to: next)
        
        return diff.day
    }
    
    var nextOccurence: Foundation.Date {
        let today = calendar.startOfDay(for: Foundation.Date())
        let comps = calendar.dateComponents([.day, .month], from: self)
        let next = calendar.nextDate(after: today, matching: comps, matchingPolicy: .nextTimePreservingSmallerComponents)!

        return next
    }
    
    func formatted(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
