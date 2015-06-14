//
//  StringExtention.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

// Converts a regular range (0..5) to a proper String.Index range.
extension String {
    public func convertRange(range: Range<Int>) -> Range<String.Index> {
        
        let startIndex = advance(self.startIndex, range.startIndex)
        let endIndex = advance(startIndex, range.endIndex + 2)
        
        return Range<String.Index>(start: startIndex, end: endIndex)
    }
}