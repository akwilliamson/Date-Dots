//
//  DateSlider.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/8/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

class ValueSlider: ASValueTrackingSlider {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.popUpViewCornerRadius = 8
        self.popUpViewArrowLength = 4
        self.setMaxFractionDigitsDisplayed(0)
        self.font = UIFont(name: "AvenirNext-Bold", size: 15)
        self.textColor = UIColor.whiteColor()
    }
    
    func setValues(max max: Float, value: Float) {
        self.maximumValue = max
        self.value = value
    }
    
    func setColorTo(color: UIColor) {
        self.thumbTintColor = color
        self.minimumTrackTintColor = color
        self.popUpViewColor = color
    }
    
    func integerValue() -> Int {
        return Int(self.value)
    }
    
    func addLabel(type: String) {
        let thumbView = self.subviews.last
        if thumbView?.viewWithTag(1) == nil {
            let label = UILabel(frame: thumbView!.bounds)
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Center
            label.textColor = UIColor.whiteColor()
            label.tag = 1
            
            switch type {
            case "month":
                label.text = "M"
            case "day":
                label.text = "D"
            case "time":
                label.text = "T"
            default:
                break
            }
            thumbView?.addSubview(label)
        }

    }
}
