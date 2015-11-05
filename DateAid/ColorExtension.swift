//
//  ColorExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/6/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension UIColor {
    
    class func birthdayColor() -> UIColor {
        return UIColor(red:  18/255.0, green: 151/255.0, blue: 147/255.0, alpha: 1)
    }
    
    class func anniversaryColor() -> UIColor {
        return UIColor(red: 239/255.0, green: 101/255.0, blue:  85/255.0, alpha: 1)
    }
    
    class func customColor() -> UIColor {
        return UIColor(red:  250/255.0, green:  190/255.0, blue:  50/255.0, alpha: 1)
    }
    
    class func confirmColor() -> UIColor {
        return UIColor(red:  102/255.0, green:  165/255.0, blue:  48/255.0, alpha: 1)
    }
}