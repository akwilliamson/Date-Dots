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
    @IBOutlet var dateLabel: UILabel!
    
    var firstName: String = "" {
        didSet {
            if (firstName != oldValue) {
                firstNameLabel.text = firstName
            }
        }
    }
    
    var lastName: String = "" {
        didSet {
            if (lastName != oldValue) {
                lastNameLabel.text = lastName
            }
        }
    }
    
    var date: String = "" {
        didSet {
            if (date != oldValue) {
                dateLabel.text = date
            }
        }
    }
}
