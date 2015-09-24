//
//  StringExtention.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension String {
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
}