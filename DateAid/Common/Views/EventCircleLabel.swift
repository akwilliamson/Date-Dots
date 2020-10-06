//
//  CircleView.swift
//  Date Dots
//
//  Created by Aaron Williamson on 10/22/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import QuartzCore

class EventCircleLabel: CircleLabel {

    // MARK: Properties

    /// TODO: Get rid of this shit
    public var index = 0

    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = color
        textColor = .white
        lineBreakMode = .byWordWrapping
    }
    
    public func updateColor(to color: UIColor) {
        backgroundColor = color
    }
}
