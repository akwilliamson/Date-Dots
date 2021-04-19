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
    
    var selectedImage: UIImage {
        switch self {
        case .address:  return UIImage(named: "selected-address")!
        case .reminder: return UIImage(named: "selected-reminder")!
        }
    }

    var unselectedImage: UIImage {
        switch self {
        case .address:  return UIImage(named: "unselected-address")!
        case .reminder: return UIImage(named: "unselected-reminder")!
        }
    }
}
