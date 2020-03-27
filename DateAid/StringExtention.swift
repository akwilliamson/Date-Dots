//
//  StringExtention.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension String {
    
    func abbreviatedName() -> String {
        let comps = self.components(separatedBy: " ")
        
        if comps.count > 1 {
            guard let char = comps[1].first else {
                return self
            }
            return comps[0] + " " + String(char)
        } else {
            return self
        }
    }
}
