//
//  ViewControllerExtension.swift
//  Date Dots
//
//  Created by Aaron Williamson on 11/17/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
