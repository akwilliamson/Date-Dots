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
