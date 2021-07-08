//
//  DateExtension.swift
//  Date Dots
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension Date {
    
    /// A date ignoring the year.
    struct CalendarDate: Comparable {
        
        let month: Int
        let day: Int
        
        init(date: Date) {
            let comps = Calendar.current.dateComponents([.month,.day], from: date)
            self.month = comps.month ?? 0
            self.day = comps.day ?? 0
        }
        
        static func <(lhs: CalendarDate, rhs: CalendarDate) -> Bool {
            if lhs.month < rhs.month {
                return true
            } else if lhs.month == rhs.month {
                return lhs.day < rhs.day
            } else {
                return false
            }
        }
    }
    
    /// The direction of which to round a specific time.
    enum DateRoundingType {
        /// Round up
        case ceiling
        /// Round down
        case floor
        /// Round in place
        case round
    }
    
    // MARK: Properties
    
    /// The date's year.
    var year: Int? {
        return dateComponents.year
    }
    /// The date's month.
    var month: Int? {
        return dateComponents.month
    }
    /// The date's day.
    var day: Int? {
        return dateComponents.day
    }
    /// The date's hour.
    var hour: Int? {
        return dateComponents.hour
    }
    /// The date's minute.
    var minute: Int? {
        return dateComponents.minute
    }
    
    // MARK: Private Properties
    
    /// The date components of the date.
    private var dateComponents: DateComponents {
        return Calendar.current.dateComponents(in: .current, from: self)
    }
    
    // MARK: Methods
    
    /// Formats a date string to the provided format.
    func formatted(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    /// Rounds the current date to a specific time, rounded to a given time interval.
    func rounded(minutes: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        return rounded(seconds: minutes * 60, rounding: rounding)
    }
    
    // MARK: Private Methods

    private func rounded(seconds: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        var roundedInterval: TimeInterval = 0
        switch rounding  {
        case .round:   roundedInterval = (timeIntervalSinceReferenceDate / seconds).rounded() * seconds
        case .ceiling: roundedInterval = ceil(timeIntervalSinceReferenceDate / seconds) * seconds
        case .floor:   roundedInterval = floor(timeIntervalSinceReferenceDate / seconds) * seconds
        }
        return Date(timeIntervalSinceReferenceDate: roundedInterval)
    }
}
