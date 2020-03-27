//
//  DateColor.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/16/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation

enum DateColor: Int {

    case birthday
    case anniversary
    case holiday
    
    var color: UIColor {
        
        switch self {
        case .birthday:    return .birthday
        case .anniversary: return .anniversary
        case .holiday:     return .custom
        }
    }
}
