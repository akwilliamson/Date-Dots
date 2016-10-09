//
//  DateCell.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/13/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {
    
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var date: Date? {
        didSet {
            if let date = date { populate(date) }
        }
    }
    
    private func populate(_ date: Date) {
        
        firstNameLabel.textColor = date.color
        if let firstName = date.firstName { firstNameLabel.text = firstName }
        if let lastName = date.lastName { lastNameLabel.text = lastName }
        if let date = date.date { dateLabel.text = date.readable }
    }
}
