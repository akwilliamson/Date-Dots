//
//  DateCell.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/13/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {
    
    var name: String = "" {
        didSet {
            if (name != oldValue) {
                nameLabel.text = name
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
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
