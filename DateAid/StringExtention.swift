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
        return substring(with: (characters.index(startIndex, offsetBy: r.lowerBound) ..< characters.index(startIndex, offsetBy: r.upperBound)))
    }
    
    func abbreviatedName() -> String {
        let comps = self.components(separatedBy: " ")
        
        if comps.count > 1 {
            guard let char = comps[1].characters.first else {
                return self
            }
            return comps[0] + " " + String(char)
        } else {
            return self
        }
    }
}
