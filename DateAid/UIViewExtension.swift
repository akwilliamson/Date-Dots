//
//  UIViewExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/3/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension UIView {
    
    func rotate360Degrees(_ duration: CFTimeInterval = 0.4) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI) * 2
        rotateAnimation.duration = duration
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func rotateBack360Degrees(_ duration: CFTimeInterval = 0.4) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = CGFloat(M_PI) * 2
        rotateAnimation.toValue = 0
        rotateAnimation.duration = duration
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func animateSlideIn(withDuration duration: TimeInterval, toPosition newPosition: CGFloat) {
        self.center.x = 600
        UIView.animate(withDuration: duration, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.center.x = newPosition
            self.center.x = newPosition
            }, completion: nil)
    }
}
