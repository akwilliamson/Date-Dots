//
//  DateExtension.swift
//  Date Dots
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

enum DateRoundingType {
    case ceiling
    case floor
    case round
}

extension Foundation.Date {
    
    var dateComponents: DateComponents {
        return Calendar.current.dateComponents(in: .current, from: self)
    }
    
    var year: Int? {
        return dateComponents.year
    }
    
    var month: Int? {
        return dateComponents.month
    }
    
    var day: Int? {
        return dateComponents.day
    }
    
    func formatted(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func rounded(minutes: TimeInterval, rounding: DateRoundingType = .round) -> Foundation.Date {
        return rounded(seconds: minutes * 60, rounding: rounding)
    }

    func rounded(seconds: TimeInterval, rounding: DateRoundingType = .round) -> Foundation.Date {
        var roundedInterval: TimeInterval = 0
        switch rounding  {
        case .round:   roundedInterval = (timeIntervalSinceReferenceDate / seconds).rounded() * seconds
        case .ceiling: roundedInterval = ceil(timeIntervalSinceReferenceDate / seconds) * seconds
        case .floor:   roundedInterval = floor(timeIntervalSinceReferenceDate / seconds) * seconds
        }
        return Foundation.Date(timeIntervalSinceReferenceDate: roundedInterval)
    }
}
