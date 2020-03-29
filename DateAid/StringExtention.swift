//
//  StringExtention.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension String {
    
    var abbreviatedName: String {
        let words = components(separatedBy: " ")
        guard words.count > 1, let lastInitial = words[1].first else { return self }

        return words[0] + " " + String(lastInitial)
    }
}
