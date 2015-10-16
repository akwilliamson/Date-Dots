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
    
    func setValues(min min: Float, max: Float, value: Float) {
        self.minimumValue = min
        self.maximumValue = max
        self.value = value
    }
}
