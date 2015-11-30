//
//  AlertControllerExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/30/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    class func generate(parentVC: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .Default) { _ in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        parentVC.presentViewController(alertController, animated: true, completion: nil)
    }
    
}