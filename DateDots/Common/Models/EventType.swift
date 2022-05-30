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
    
    var image: UIImage {
        return UIImage(named: rawValue)!
    }
    
    var color: UIColor {
        switch self {
        case .birthday:    return UIColor.birthday
        case .anniversary: return UIColor.anniversary
        case .custom:      return UIColor.custom
        }
    }

    var emoji: String {
        switch self {
        case .birthday:    return "🎈"
        case .anniversary: return "💞"
        case .custom:      return "💡"
        }
    }
}
