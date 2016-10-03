//
//  DateExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension Foundation.Date {
    
    var formatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: self)
    }

    init(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateStringFormatter.date(from: dateString)!
        (self as NSDate).init(timeInterval: 0, since: date)
    }
    
    func daysBetween() -> Int {
        let components = getComponents()
        (components as NSDateComponents).setValue(2015, forComponent: .year) // Static year component for now, should change to dynamic
        let newDate = getCalendar().date(from: components)
        let dateDay = (getCalendar() as NSCalendar).ordinality(of: .day, in: .year, for: newDate!)
        let nowDay = (getCalendar() as NSCalendar).ordinality(of: .day, in: .year, for: Foundation.Date())
        var difference = dateDay - nowDay
        if difference < 0 {
            difference += 365
        }
        return difference
    }
    
    func readableDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: self)
    }
    
    func ageTurning() -> Int {
        let date = (getCalendar() as NSCalendar).components(.year, from: self, to: Foundation.Date(), options: [])
        return date.year! + 1
    }
    
    func getCalendar() -> Calendar {
        return Calendar.current
    }
    
    func getComponents() -> DateComponents {
        return (getCalendar() as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self)
    }
    
    func getYear() -> Int {
        return getComponents().year!
    }
    
    func getMonth() -> Int {
        return getComponents().month!
    }
    
    func getDay() -> Int {
        return getComponents().day!
    }
    
    func getHour() -> Int {
        return getComponents().hour!
    }
    
    func getMinute() -> Int {
        return getComponents().minute!
    }
    
    func getSecond() -> Int {
        return getComponents().second!
    }
    
    func setYear(_ year: Int) -> Foundation.Date {
        var components = getComponents()
        components.year = year
        components.month = self.getMonth()
        components.day = self.getDay()
        components.hour = self.getHour()
        components.minute = self.getMinute()
        components.second = self.getSecond()
        var date = getCalendar().date(from: components)!
        if date == (date as NSDate).earlierDate(Foundation.Date()) {
            components.year = year + 1
            date = getCalendar().date(from: components)!
        }
        return date
    }
}
