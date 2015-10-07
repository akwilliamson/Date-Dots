//
//  DateSlider.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/7/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

class DateSlider: ASValueTrackingSlider {

    override func thumbRectForBounds(bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        
        let smallerBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width-15, height: bounds.height-15)
        
        return super.thumbRectForBounds(smallerBounds, trackRect: rect, value: value)
    }
}