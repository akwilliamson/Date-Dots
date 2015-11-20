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
}