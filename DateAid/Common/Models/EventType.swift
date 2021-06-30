//
//  DateType.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/2/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

enum EventType: String, CaseIterable {

    case birthday
    case anniversary
    case custom
    case other
    
    var key: String {
        return "event-\(rawValue)"
    }
    
    var image: UIImage {
        return UIImage(named: rawValue)!
    }
    
    var color: UIColor {
        switch self {
        case .birthday:    return UIColor.birthday
        case .anniversary: return UIColor.anniversary
        case .custom:      return UIColor.custom
        case .other:       return UIColor.other
        }
    }

    var emoji: String {
        switch self {
        case .birthday:    return "🎈"
        case .anniversary: return "💞"
        case .custom:      return "🎉"
        case .other:       return "💡"
        }
    }
}
