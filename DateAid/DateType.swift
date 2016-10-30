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
    
    var lowercased: String {
        return self.rawValue.lowercased()
    }
    
    var decorationImage: UIImage? {
        
        switch self {
        case .birthday:
            return UIImage(named: "balloon.png")
        case .anniversary:
            return UIImage(named: "heart.png")
        case .holiday:
            return UIImage(named: "calendar.png")
        }
    }
}

enum FilterDateType: Int {

    case all
    case birthday
    case anniversary
    case holiday
    
    var value: String {
        switch self {
        case .all:
            return "All"
        case .birthday:
            return "Birthday"
        case .anniversary:
            return "Anniversary"
        case .holiday:
            return "Holiday"
        }
    }
    
    var pluralValue: String {
        switch self {
        case .all:
            return "All"
        case .birthday:
            return "Birthdays"
        case .anniversary:
            return "Anniversaries"
        case .holiday:
            return "Holidays"
        }
    }
}
