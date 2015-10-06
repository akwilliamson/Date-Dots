//
//  DateDetailsVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/23/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

class DateDetailsVC: UIViewController {

    var date: Date?
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysUntilLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateValue = date!.date
        dateFormatter.dateFormat = "dd MMM"
        fullNameLabel.text = date!.name
        dateLabel.text = "\(dateFormatter.stringFromDate(dateValue))"
        daysUntilLabel.text = "\(dateValue.daysBetween()) days away"
        ageLabel.text = "turning \(dateValue.ageTurning())"
    }
    
    @IBAction func editDate(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let addDateVC = segue.destinationViewController as! AddDateViewController
        addDateVC.type = date!.type
        addDateVC.name = date!.name
        addDateVC.date = date!.date
    }
}