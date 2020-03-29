//
//  DateType.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/2/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation

enum DateType: String {

    case birthday    = "Birthday"
    case anniversary = "Anniversary"
    case holiday     = "Holiday"
    case other       = "Other"
    
    var lowercased: String {
        return rawValue.lowercased()
    }
    
    var iconImage: UIImage? {
        
        switch self {
        case .birthday:    return UIImage(named: "balloon.png")
        case .anniversary: return UIImage(named: "heart.png")
        case .holiday:     return UIImage(named: "calendar.png")
        case .other:       return UIImage(named: "calendar.png")
        }
    }

    var pluralString: String {
        switch self {
        case .birthday:    return "Birthdays"
        case .anniversary: return "Anniversaries"
        case .holiday:     return "Holidays"
        case .other:       return "Other Dates"
        }
    }
}
