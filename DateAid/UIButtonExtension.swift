//
//  UIButtonExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/19/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension UIButton {
    
    func animateInAndOut() {
        self.titleLabel!.transform = CGAffineTransformScale(self.transform, 0.3, 0.3);
        UIControl.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.Repeat,.Autoreverse,.AllowUserInteraction], animations: { () -> Void in
            self.titleLabel!.transform = CGAffineTransformScale(self.transform, 1, 1);
        }, completion: nil)
    }
    
}