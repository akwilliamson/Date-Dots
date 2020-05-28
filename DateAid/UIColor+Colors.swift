//
//  ColorExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/6/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var compatibleSecondaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .black
        }
    }
    
    class var compatibleSystemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }

    class var compatibleSystemGray3: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray3
        } else {
            return UIColor.white
        }
    }

    class var compatiblePlaceholderText: UIColor {
        if #available(iOS 13.0, *) {
            return .placeholderText
        } else {
            return UIColor(red: 235/255, green: 235/255, blue: 245/255, alpha: 1)
        }
    }

    class var compatibleLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return UIColor(white: 72/255, alpha: 1)
        }
    }
    
    class var confirm: UIColor {
        return UIColor(red:  102/255, green: 165/255, blue: 48/255, alpha: 1)
    }
}
