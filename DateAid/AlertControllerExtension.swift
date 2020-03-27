//
//  AlertControllerExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/30/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    class func generate(_ parentVC: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        parentVC.present(alertController, animated: true, completion: nil)
    }
    
}
