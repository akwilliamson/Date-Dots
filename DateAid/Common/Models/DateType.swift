//
//  DateType.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/2/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import UIKit

enum DateType: String {

    case birthday
    case anniversary
    case holiday
    case other
    
    public var color: UIColor {
        switch self {
        case .birthday:    return UIColor(red:  17/255.0, green: 132/255.0, blue: 151/255.0, alpha: 1)
        case .anniversary: return UIColor(red: 214/255.0, green: 87/255.0, blue: 69/255.0, alpha: 1)
        case .holiday:     return UIColor(red:  87/255.0, green: 153/255.0, blue: 22/255.0, alpha: 1)
        case .other:       return UIColor(red:  229/255.0, green: 183/255.0, blue: 15/255.0, alpha: 1)
        }
    }
    
    public var selectedImage: UIImage {
        switch self {
        case .birthday:    return UIImage(named: "selected-birthday.png")!
        case .anniversary: return UIImage(named: "selected-anniversary.png")!
        case .holiday:     return UIImage(named: "selected-holiday.png")!
        case .other:       return UIImage(named: "selected-other.png")!
        }
    }

    public var unselectedImage: UIImage {
        switch self {
        case .birthday:    return UIImage(named: "unselected-birthday.png")!
        case .anniversary: return UIImage(named: "unselected-anniversary.png")!
        case .holiday:     return UIImage(named: "unselected-holiday.png")!
        case .other:       return UIImage(named: "unselected-other.png")!
        }
    }
}
