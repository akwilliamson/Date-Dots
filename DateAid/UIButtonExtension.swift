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
        self.imageView?.transform = CGAffineTransformScale(self.transform, 0.7, 0.7);
        UIControl.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.Repeat,.Autoreverse,.AllowUserInteraction], animations: { () -> Void in
            self.imageView?.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
        }, completion: nil)
    }
    
    func stopAnimating() {
        self.imageView!.layer.removeAllAnimations()
    }
    
}