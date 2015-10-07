//
//  DateSlider.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/7/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

class DateSlider: ASValueTrackingSlider {

    func setSmallImage(image: UIImage) {
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.7, 0.7))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
        
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.setThumbImage(scaledImage, forState: .Normal)
    }
    
}