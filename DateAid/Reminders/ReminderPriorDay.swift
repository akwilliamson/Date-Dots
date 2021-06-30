//
//  ReminderDaysBefore.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/9/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import Foundation

enum ReminderDayPrior: Int {
    
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    
    var infoText: String {
        switch self {
        case .zero: return "Day of"
        default:    return "\(rawValue) day before"
        }
    }
}
