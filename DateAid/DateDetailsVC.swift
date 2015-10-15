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
    
// MARK: PROPERTIES

    var managedContext: NSManagedObjectContext?
    var date: Date!

// MARK: OUTLETS
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysUntilLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureFormattedDate()
        configureDaysUntil()
        configureAge()
    }
    
    func configureNavBar() {
        self.title = date.name!.abbreviateName()
    }
    
    func configureFormattedDate() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let dateString = dateFormatter.stringFromDate(date.date!)
        dateLabel.text = dateString
    }
    
    func configureDaysUntil() {
        let numberOfDays = date.date!.daysBetween()
        daysUntilLabel.text = "\(numberOfDays) days away"
    }
    
    func configureAge() {
        ageLabel.text = "turning \(date.date!.ageTurning())"
    }
    
// MARK: ACTIONS
    
    @IBAction func editDate(sender: AnyObject) {
    }
    
// MARK: SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let addDateVC = segue.destinationViewController as! AddDateVC
        addDateVC.isBeingEdited = true
        addDateVC.dateToSave = date
    }
}