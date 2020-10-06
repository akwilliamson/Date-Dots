//
//  EventReminderWindow.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/9/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import Foundation

enum EventReminderDaysBefore: Int {
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    
    var pickerText: String {
        switch self {
        case .zero:
            return "Day of"
        default:
            return "\(rawValue) day before"
        }
    }
    
    var reminderText: String {
        switch self {
        case .zero:
            return "is today"
        case .one:
            return "is tomorrow"
        default:
            return "is \(rawValue) days away"
        }
    }
}
