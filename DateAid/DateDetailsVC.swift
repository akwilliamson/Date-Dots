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
        styleLabels()
        configureCountdown()
        configureDate()
        configureAge()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dateLabel.center.y = -50
        daysUntilLabel.center.y = -50
        ageLabel.center.y = -50
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.ageLabel.center.y = 84
        }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.daysUntilLabel.center.y = 84
        }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.dateLabel.center.y = 84
        }, completion: nil)
        
    }
    
    func configureNavBar() {
        title = date.name!.abbreviateName()
    }
    
    func styleLabels() {
        let labelsArray = [dateLabel, daysUntilLabel, ageLabel]
        for label in labelsArray {
            label.layer.cornerRadius = 47
            label.clipsToBounds = true
            label.textColor = UIColor.whiteColor()
            switch date.type! {
            case "birthday":
                label.backgroundColor = UIColor.birthdayColor()
            case "anniversary":
                label.backgroundColor = UIColor.anniversaryColor()
            case "holiday":
                label.backgroundColor = UIColor.holidayColor()
            default:
                break
            }
        }
    }
    
    func configureDate() {
        let text = date!.date!.readableDate()
        dateLabel.text = text.stringByReplacingOccurrencesOfString(" ", withString: "\n")
    }
    
    func configureCountdown() {
        let numberOfDays = date.date!.daysBetween()
        daysUntilLabel.text = "In \(numberOfDays)\ndays"
    }
    
    func configureAge() {
        ageLabel.text = "Turning\n\(date.date!.ageTurning())"
    }
    
// MARK: SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let addDateVC = segue.destinationViewController as! AddDateVC
        addDateVC.isBeingEdited = true
        addDateVC.dateToSave = date
        addDateVC.managedContext = managedContext
    }
}