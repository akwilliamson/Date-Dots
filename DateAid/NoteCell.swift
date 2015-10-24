//
//  NoteCell.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/24/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    
    var name: String = "" {
        didSet {
            if (name != oldValue) {
                nameLabel.text = name
            }
        }
    }
}
