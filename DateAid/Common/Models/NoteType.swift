//
//  NoteType.swift
//  DateAid
//
//  Created by Aaron Williamson on 2/24/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

enum NoteType: String {
    
    case gifts
    case plans
    case other
    
    var key: String {
        return "note-\(rawValue)"
    }
    
    var selectedImage: UIImage {
        switch self {
        case .gifts: return UIImage(named: "selected-note-gifts")!
        case .plans: return UIImage(named: "selected-note-plans")!
        case .other: return UIImage(named: "selected-note-other")!
        }
    }

    var unselectedImage: UIImage {
        switch self {
        case .gifts: return UIImage(named: "unselected-note-gifts")!
        case .plans: return UIImage(named: "unselected-note-plans")!
        case .other: return UIImage(named: "unselected-note-other")!
        }
    }
}
