//
//  EventReminderWindow.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/9/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import Foundation

enum EventReminderWindow: Int {
    case dayOf
    case oneDay
    case twoDays
    case threeDays
    case fourDays
    case fiveDays
    case sixDays
    case sevenDays
    
    var pickerText: String {
        switch self {
        case .dayOf:     return "Day of"
        case .oneDay:    return "\(rawValue) day before"
        case .twoDays:   return "\(rawValue) days before"
        case .threeDays: return "\(rawValue) days before"
        case .fourDays:  return "\(rawValue) days before"
        case .fiveDays:  return "\(rawValue) days before"
        case .sixDays:   return "\(rawValue) days before"
        case .sevenDays: return "\(rawValue) days before"
        }
    }
    
    var reminderText: String {
        switch self {
        case .dayOf:     return "is today"
        case .oneDay:    return "is tomorrow"
        case .twoDays:   return "is 2 days away"
        case .threeDays: return "is 3 days away"
        case .fourDays:  return "is 4 days away"
        case .fiveDays:  return "is 5 days away"
        case .sixDays:   return "is 6 days away"
        case .sevenDays: return "is 7 days away"
        }
    }
}
