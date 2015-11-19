//
//  NavigationCell.swift
//  DateAid
//
//  Created by Aaron Williamson on 11/17/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import Foundation

class NavigationCell: UITableViewCell {

    @IBOutlet weak var containerLabel: CircleLabel!
    @IBOutlet weak var navigationIcon: UIImageView!
    @IBOutlet weak var navigationTitle: UILabel!
    
    func setIcon(forIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationIcon.image = UIImage(named: "all.png")
        case 1:
            self.navigationIcon.image = UIImage(named: "balloon.png")
        case 2:
            self.navigationIcon.image = UIImage(named: "heart.png")
        case 3:
            self.navigationIcon.image = UIImage(named: "calendar.png")
        default:
            return
        }
    }
    
}