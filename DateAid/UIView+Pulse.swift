//
//  UIView+Pulse.swift
//  DateAid
//
//  Created by Aaron Williamson on 3/8/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

extension UIView {
    
    func pulse(intensity: CGFloat, duration: Double, loop: Bool) {
        UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .autoreverse], animations: {
            loop ? nil : UIView.setAnimationRepeatCount(1)
            self.transform = CGAffineTransform(scaleX: intensity, y: intensity)
        }) { (true) in
            self.transform = .identity
        }
    }
}

