//
//  EventReminderCircleLabel.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/1/20.
//  Copyright © 2020 Aaron Williamson. All rights reserved.
//

import UIKit

class EventReminderCircleLabel: CircleLabel {

    // MARK: Properties

    public let daysBefore: EventReminderDaysBefore

    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(daysBefore: EventReminderDaysBefore) {
        self.daysBefore = daysBefore
        super.init(frame: .zero)
        backgroundColor = UIColor.randomColor()
        textColor = .white
        text = "\(daysBefore.rawValue)"
        font = FontType.avenirNextDemiBold(25).font
        lineBreakMode = .byWordWrapping
    }
}
