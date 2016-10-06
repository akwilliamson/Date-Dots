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
        switch self {
        default:
            return self.rawValue.lowercased()
        }
    }
}
