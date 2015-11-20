//
//  SlideLabel.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/19/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

class SlideLabel: UILabel {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func animateSlideIn(withDuration duration: NSTimeInterval, toPosition newPosition: CGFloat) {
        self.center.x = 600
        UIView.animateWithDuration(duration, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.center.x = newPosition
            self.center.x = newPosition
        }, completion: nil)
    }

}