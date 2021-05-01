//
//  ReminderCircleLabel.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/1/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class ReminderCircleLabel: CircleLabel {

    // MARK: Properties

    public let daysBefore: ReminderDaysBefore

    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(daysBefore: ReminderDaysBefore) {
        self.daysBefore = daysBefore
        super.init(frame: .zero)
        backgroundColor = UIColor.randomColor()
        textColor = .white
        text = "\(daysBefore.rawValue)"
        font = FontType.avenirNextDemiBold(25).font
        lineBreakMode = .byWordWrapping
    }
}
