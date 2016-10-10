//
//  DateExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension Foundation.Date {
    
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
        if let age = calendar.dateComponents([.year], from: self, to: Foundation.Date()).year {
            return age + 1
        }
        return nil
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
    
    init(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateStringFormatter.date(from: dateString)!
        
        self.init(timeInterval: 0, since: date)
    }
    
    func formatted(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
