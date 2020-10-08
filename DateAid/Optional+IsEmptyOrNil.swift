//
//  StringExtention.swift
//  Date Dots
//
//  Created by Aaron Williamson on 6/14/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {

    /// Determines whether a string is either empty or nil.
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}
