//
//  DateExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension NSDate {

    convenience init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
    
    func daysBetween() -> Int {
        let unitFlags = NSCalendarUnit.Day
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(unitFlags, fromDate: self, toDate: NSDate(), options: [])
        var result = 365 - (components.day)
        while result < 0 {
            result = result + 365
        }
        return result
    }
    
    func ageTurning() -> Int {
        let ageComponents = NSCalendar.currentCalendar()
        let date = ageComponents.components(.Year, fromDate: self, toDate: NSDate(), options: [])
        return date.year + 1
    }
}