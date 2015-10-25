//
//  DateDetailsVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 6/23/15.
//  Copyright (c) 2015 Aaron Williamson. All rights reserved.
//

import UIKit
import CoreData

protocol SetNotificationDelegate {
    func reloadNotificationView()
}

class DateDetailsVC: UIViewController {
    
// MARK: PROPERTIES

    var managedContext: NSManagedObjectContext?
    var date: Date!
    var localNotificationFound: Bool?
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "holiday": UIColor.holidayColor()]

// MARK: OUTLETS
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysUntilLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var reminderImageContainerView: UIView!
    @IBOutlet weak var reminderImage: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!
    
    @IBOutlet weak var notesButton: UIButton!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotificationView()
        configureNavBar()
        styleLabels()
        configureCountdown()
        configureDate()
        configureAge()
        if let dateType = date.type {
            reminderImage.tintColor = colorForType[dateType]
            reminderLabel.textColor = colorForType[dateType]
            notesButton.backgroundColor = colorForType[dateType]
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("editNotification:"))
        gestureRecognizer.numberOfTapsRequired = 1
        reminderImage.addGestureRecognizer(gestureRecognizer)
        reminderImage.userInteractionEnabled = true
        
        if let street = date.address?.street {
            let streetText = (street.characters.count > 0) ? street : "Mailing Address not set"
            addressLabel.text = streetText
        }
        if let region = date.address?.region {
            let regionText = (region.characters.count > 0) ? region : "City, State Zip not set"
            regionLabel.text = regionText
        }
    }
    
    func setNotificationView() {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if let notificationID = notification.userInfo!["date"] as? String {
                if notificationID == String(date.objectID.URIRepresentation()) {
                    reminderImage.image = UIImage(named: "reminder-on.png")?.imageWithRenderingMode(.AlwaysTemplate)
                    let daysPrior = Int(notification.userInfo!["daysPrior"] as! String)!
                    let hourOfDay = Int(notification.userInfo!["hoursAfter"] as! String)!
                    let dayText = (daysPrior == 1) ? "\(daysPrior) day before " : "\(daysPrior) days before "
                    let hourText = (hourOfDay < 13) ? "at \(hourOfDay)am" : "at \(hourOfDay - 12)pm"
                    reminderLabel.text = dayText + hourText
                    localNotificationFound = true
                }
            }
        }
        if localNotificationFound != true {
            reminderImage.image = UIImage(named: "reminder-off.png")?.imageWithRenderingMode(.AlwaysTemplate)
            reminderLabel.text = "Alert Not Set"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        animateDropInLabelFor(ageLabel, fromPosition: -50, delay: 0)
        animateDropInLabelFor(daysUntilLabel, fromPosition: -50, delay: 0.1)
        animateDropInLabelFor(dateLabel, fromPosition: -50, delay: 0.2)
        
        reminderView.center.x = self.view.frame.width + reminderLabel.frame.width
        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.reminderView.center.x = self.view.center.x
            }, completion: nil)
    }
    
    func editNotification(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier("ShowNotification", sender: self)
    }
    
    func animateDropInLabelFor(label: UILabel, fromPosition: CGFloat, delay: NSTimeInterval) {
        label.center.y = fromPosition
        UIView.animateWithDuration(1, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            label.center.y = 84
        }, completion: nil)
    }
    
    @IBAction func unwindToDateDetails(segue: UIStoryboardSegue) {
        self.loadView()
    }
    
    func configureNavBar() {
        if let abbreviatedName = date.name?.abbreviateName() {
            title = abbreviatedName
        }
    }
    
    func styleLabels() {
        if let dateType = date.type {
            ageLabel.backgroundColor = colorForType[dateType]
            daysUntilLabel.backgroundColor = colorForType[dateType]
            dateLabel.backgroundColor = colorForType[dateType]
        }
    }

    func configureDate() {
        if let readableDate = date?.date?.readableDate() {
            dateLabel.text = readableDate.stringByReplacingOccurrencesOfString(" ", withString: "\n")
        }
    }
    
    func configureCountdown() {
        if let numberOfDays = date.date?.daysBetween() {
            if numberOfDays == 0 {
                daysUntilLabel.text = "Today"
            } else if numberOfDays == 1 {
                daysUntilLabel.text = "In \(numberOfDays)\nday"
            } else {
                daysUntilLabel.text = "In \(numberOfDays)\ndays"
            }
        }
    }
    
    func configureAge() {
        if let year = date.date?.getYear() {
            if year == 1604 {
                ageLabel.text = "Age\nN/A"
            } else {
                switch date!.type! {
                case "birthday":
                    ageLabel.text = "Turning\n\(date.date!.ageTurning())"
                case "anniversary", "holiday":
                    ageLabel.text = "Year\n#\(date.date!.ageTurning())"
                default:
                    break
                }
            }
        }
    }
    
// MARK: SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditDate" {
            let addDateVC = segue.destinationViewController as! AddDateVC
            addDateVC.isBeingEdited = true
            addDateVC.dateToSave = date
            addDateVC.managedContext = managedContext
            addDateVC.notificationDelegate = self
        }
        if segue.identifier == "ShowNotes" {
            let notesTableVC = segue.destinationViewController as! NotesTableVC
            notesTableVC.typeColor = colorForType[date!.type!]
        }
        if segue.identifier == "ShowNotification" {
            let singlePushSettingsVC = segue.destinationViewController as! SinglePushSettingsVC
            singlePushSettingsVC.date = date
            singlePushSettingsVC.notificationDelegate = self
        }
    }
}

extension DateDetailsVC: SetNotificationDelegate {
    
    func reloadNotificationView() {
        setNotificationView()
    }
}


