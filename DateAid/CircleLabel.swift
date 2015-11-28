//
//  CircleView.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/22/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class CircleLabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func drawRect(rect: CGRect) {
        self.layer.cornerRadius = self.bounds.width/2
        self.clipsToBounds = true
        super.drawRect(rect)
    }
    
    override func drawTextInRect(rect: CGRect) {
        self.textColor = UIColor.whiteColor()
        super.drawTextInRect(rect)
    }
    
    func setProperties(borderWidth: Float, borderColor: UIColor) {
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.CGColor
    }
    
    func animateDropIn(withDelay delay: NSTimeInterval) {
        self.center.y = -50
        UIView.animateWithDuration(1, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.center.y = 84
            }, completion: nil)
    }
    
    func slideRight(forDuration duration: NSTimeInterval, inView view: UIView, closure: ()) {
        UIView.animateWithDuration(duration, animations: { _ in
            self.center.x = view.frame.width - (self.center.x)
            }) { _ in
                closure
        }
    }
    
    func addTapGestureRecognizer(forAction action: String) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(action))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func animate(intoView view: UIView, toPosition position: CGFloat, withDelay delay: NSTimeInterval) {
        self.center.x = -view.frame.width - self.frame.height
        UIView.animateWithDuration(0.8, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: { _ in
            self.center.x = position
            }) { _ in
        }
    }
}