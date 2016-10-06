//
//  ArrayExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/22/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func shift() {
        var shifted = self[1..<self.count]
        shifted += self[0..<1]
        self = Array(shifted)
    }
    
}
