//
//  ArrayExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/22/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension Array {
    
    var last: Element? {
        return self[self.endIndex - 1]
    }
    
}