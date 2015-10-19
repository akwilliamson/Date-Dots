//
//  SinglePushSettingsVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/18/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class SinglePushSettingsVC: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayLabel.layer.cornerRadius = 47
        dayLabel.clipsToBounds = true
        timeLabel.layer.cornerRadius = 47
        timeLabel.clipsToBounds = true
        soundLabel.layer.cornerRadius = 47
        soundLabel.clipsToBounds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dayLabel.center.y = -50
        timeLabel.center.y = -50
        soundLabel.center.y = -50
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.dayLabel.center.y = 84
            }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.timeLabel.center.y = 84
            }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.soundLabel.center.y = 84
            }, completion: nil)
    }
    
}
