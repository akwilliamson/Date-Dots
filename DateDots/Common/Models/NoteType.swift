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
    case misc
    
    var image: UIImage {
        return UIImage(named: rawValue)!
    }
}
