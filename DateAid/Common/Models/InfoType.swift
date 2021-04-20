//
//  InfoType.swift
//  DateAid
//
//  Created by Aaron Williamson on 4/18/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

enum InfoType: String {
    
    case address
    case reminder
    
    var key: String {
        return "info-\(rawValue)"
    }
    
    var image: UIImage {
        switch self {
        case .address:  return UIImage(named: "address")!
        case .reminder: return UIImage(named: "reminder")!
        }
    }
}
