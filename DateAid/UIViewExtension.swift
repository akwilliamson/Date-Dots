//
//  UIViewExtension.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/3/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

extension UIView {
    
    func rotate360Degrees(duration: CFTimeInterval = 0.4, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI) * 2
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
    
    func rotateBack360Degrees(duration: CFTimeInterval = 0.4, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = CGFloat(M_PI) * 2
        rotateAnimation.toValue = 0
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
    
}