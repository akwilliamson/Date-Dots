//
//  UIView+Spring.swift
//  DateAid
//
//  Created by Aaron Williamson on 7/7/21.
//  Copyright © 2021 Aaron Williamson. All rights reserved.
//

import UIKit

extension UIView {
    
    /// A custom scale and spring effect upon selection.
    func spring(
        scale: CGFloat = 0.8,
        duration: TimeInterval = 1,
        damping: CGFloat = 0.2,
        velocity: CGFloat = 6
    ) {
        transform = CGAffineTransform(scaleX: scale, y: scale)
        
        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6,
            options: .allowUserInteraction)
        {
            self.transform = .identity
        } completion: { _ in }
    }
}
