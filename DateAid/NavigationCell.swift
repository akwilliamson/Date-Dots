//
//  NavigationCell.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/22/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class NavigationCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var name: String = "" {
        didSet {
            if (name != oldValue) {
                nameLabel.text = name
            }
        }
    }
}
