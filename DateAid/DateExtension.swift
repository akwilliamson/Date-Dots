//
//  DateExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension NSDate {

    convenience init(dateString: String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        print(dateString)
        let date = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval: 0, sinceDate: date)
    }
    
    func daysBetween() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: self)
        // Static year component for now, should change to dynamic
        dateComponents.setValue(2015, forComponent: .Year)
        let newDate = calendar.dateFromComponents(dateComponents)
        
        let dateDay = calendar.ordinalityOfUnit(.Day, inUnit: .Year, forDate: newDate!)
        let nowDay = calendar.ordinalityOfUnit(.Day, inUnit: .Year, forDate: NSDate())
        var difference = dateDay - nowDay
        if difference < 0 {
            difference += 365
        }
        return difference
    }
    
    func ageTurning() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.components(.Year, fromDate: self, toDate: NSDate(), options: [])
        return date.year + 1
    }
}