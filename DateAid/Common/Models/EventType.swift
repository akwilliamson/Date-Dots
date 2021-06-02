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
    case holiday = "custom"
    case other = "event"
    
    var key: String {
        return "event-\(rawValue)"
    }
    
    var image: UIImage {
        switch self {
        case .birthday:    return UIImage(named: "birthday")!
        case .anniversary: return UIImage(named: "anniversary")!
        case .holiday:     return UIImage(named: "holiday")!
        case .other:       return UIImage(named: "custom")!
        }
    }
    
    var color: UIColor {
        switch self {
        case .birthday:    return UIColor(red:  17/255.0, green: 132/255.0, blue: 151/255.0, alpha: 1)
        case .anniversary: return UIColor(red: 214/255.0, green: 87/255.0, blue: 69/255.0, alpha: 1)
        case .holiday:     return UIColor(red:  87/255.0, green: 153/255.0, blue: 22/255.0, alpha: 1)
        case .other:       return UIColor(red:  229/255.0, green: 183/255.0, blue: 15/255.0, alpha: 1)
        }
    }

    var emoji: String {
        switch self {
        case .birthday:    return "🎈"
        case .anniversary: return "💞"
        case .holiday:     return "🎉"
        case .other:       return "💡"
        }
    }
}
