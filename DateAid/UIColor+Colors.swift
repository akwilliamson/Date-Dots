//
//  ColorExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/6/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var standardTintColor: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .black
        }
    }
    
    class var standardBackgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }

    class var navigationGray: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray3
        } else {
            return UIColor.white
        }
    }

    class var textGray: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return UIColor(white: 72/255.0, alpha: 1)
        }
    }
    
    class var confirm: UIColor {
        return UIColor(red:  102/255.0, green: 165/255.0, blue: 48/255.0, alpha: 1)
    }
}
