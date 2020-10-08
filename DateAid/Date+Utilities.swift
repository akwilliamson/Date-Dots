//
//  DateExtension.swift
//  Date Dots
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension Foundation.Date {
    
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
    func rounded(minutes: TimeInterval, rounding: DateRoundingType = .round) -> Foundation.Date {
        return rounded(seconds: minutes * 60, rounding: rounding)
    }
    
    // MARK: Private Methodss

    private func rounded(seconds: TimeInterval, rounding: DateRoundingType = .round) -> Foundation.Date {
        var roundedInterval: TimeInterval = 0
        switch rounding  {
        case .round:   roundedInterval = (timeIntervalSinceReferenceDate / seconds).rounded() * seconds
        case .ceiling: roundedInterval = ceil(timeIntervalSinceReferenceDate / seconds) * seconds
        case .floor:   roundedInterval = floor(timeIntervalSinceReferenceDate / seconds) * seconds
        }
        return Foundation.Date(timeIntervalSinceReferenceDate: roundedInterval)
    }
}
