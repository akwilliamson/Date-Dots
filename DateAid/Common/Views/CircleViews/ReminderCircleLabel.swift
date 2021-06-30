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

    let dayPrior: ReminderDayPrior

    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(dayPrior: ReminderDayPrior) {
        self.dayPrior = dayPrior
        super.init(frame: .zero)
        lineBreakMode = .byWordWrapping
        textColor = .white
        font = FontType.avenirNextDemiBold(25).font
        text = "\(dayPrior.rawValue)"
    }
}
