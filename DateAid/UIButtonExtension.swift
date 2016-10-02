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
        self.imageView?.transform = self.transform.scaledBy(x: 0.7, y: 0.7);
        UIControl.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.repeat,.autoreverse,.allowUserInteraction], animations: { () -> Void in
            self.imageView?.transform = self.transform.scaledBy(x: 0.8, y: 0.8);
        }, completion: nil)
    }
    
    func stopAnimating() {
        self.imageView!.layer.removeAllAnimations()
    }
    
}
