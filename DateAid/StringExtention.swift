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
    
    func abbreviateName() -> String {
        return self.containsString(" ") ? self[0...((self as NSString).rangeOfString(" ").location + 1)] : (self as String)
    }
    
    func firstName() -> String {
        return self.containsString(" ") ? self[0...((self as NSString).rangeOfString(" ").location)] : (self as String)
    }
    
    func lastName() -> String? {
        let lastNameString: String?
        let components = self.componentsSeparatedByString(" ")
        if components.count == 2 || components.count == 3 {
            guard let lastName = components.last else { return "" }
            lastNameString = lastName
        } else {
            lastNameString = ""
        }
        return lastNameString
    }
    
    func associatedColor() -> UIColor {
        switch self {
        case "all", "All":
            return UIColor.grayColor()
        case "birthday", "Birthdays":
            return UIColor.birthdayColor()
        case "anniversary", "Anniversaries":
            return UIColor.anniversaryColor()
        case "custom", "Custom":
            return UIColor.customColor()
        default:
            return UIColor.birthdayColor()
        }
    }
}