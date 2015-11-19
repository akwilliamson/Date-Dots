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
    
}