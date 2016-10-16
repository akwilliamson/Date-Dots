//
//  Event.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/15/16.
//  Copyright © 2016 Aaron Williamson. All rights reserved.
//

import Foundation

enum Event: String {

    case dates
    
    var value: String {
        return self.rawValue.uppercased() + " View Controller"
    }

}
