//
//  ViewControllerExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/17/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension UIViewController {

    func logEvents(forString string: String) {
        Flurry.logEvent(string)
        AppAnalytics.logEvent(string)
    }
    
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}