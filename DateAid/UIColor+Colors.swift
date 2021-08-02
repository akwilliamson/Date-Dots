//
//  ColorExtension.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/6/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var compatibleSecondaryLabel: UIColor {
        return .secondaryLabel
    }
    
    class var compatibleSystemBackground: UIColor {
        return .systemBackground
    }
    
    class var compatibleSystemGray: UIColor {
        return .systemGray
    }

    class var compatibleSystemGray3: UIColor {
        return .systemGray3
    }

    class var compatiblePlaceholderText: UIColor {
        return .placeholderText
    }

    class var compatibleLabel: UIColor {
        return .label
    }
    
    class var confirm: UIColor {
        return UIColor(red:  102/255, green: 165/255, blue: 48/255, alpha: 1)
    }
    
    class var birthday: UIColor {
        return UIColor(red:  17/255.0, green: 132/255.0, blue: 151/255.0, alpha: 1)
    }
    
    class var anniversary: UIColor {
        return UIColor(red: 214/255.0, green: 87/255.0, blue: 69/255.0, alpha: 1)
    }
    
    class var custom: UIColor {
        return UIColor(red:  229/255.0, green: 183/255.0, blue: 15/255.0, alpha: 1)
    }
}


import Foundation

typealias Dispatch = DispatchQueue

extension Dispatch {

    static func background(_ task: @escaping () -> ()) {
        Dispatch.global(qos: .background).async {
            task()
        }
    }

    static func main(_ task: @escaping () -> ()) {
        Dispatch.main.async {
            task()
        }
    }
}
