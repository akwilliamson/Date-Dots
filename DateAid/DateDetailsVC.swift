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
    
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "holiday": UIColor.holidayColor()]

// MARK: OUTLETS
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysUntilLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var reminderImageContainerView: UIView!
    @IBOutlet weak var reminderImage: UIImageView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    @IBOutlet weak var notesButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        styleLabels()
        configureCountdown()
        configureDate()
        configureAge()
        
        if let dateType = date.type {
            reminderImageContainerView.layer.borderColor = colorForType[dateType]?.CGColor
            reminderImage.tintColor = colorForType[dateType]
            notesButton.backgroundColor = colorForType[dateType]
            notificationView.backgroundColor = colorForType[dateType]
        }
        
        reminderImageContainerView.layer.cornerRadius = 33
        reminderImageContainerView.clipsToBounds = true
        reminderImageContainerView.layer.borderWidth = 2
        reminderImage.image = reminderImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        reminderImage.userInteractionEnabled = true
        notificationView.layer.cornerRadius = 10
        notificationView.clipsToBounds = true
        notificationView.layer.borderWidth = 2
        notificationView.layer.borderColor = UIColor.whiteColor().CGColor
        dismissButton.layer.cornerRadius = 8
        dismissButton.clipsToBounds = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("showNotificationView:"))
        gestureRecognizer.numberOfTapsRequired = 1
        reminderImage.addGestureRecognizer(gestureRecognizer)
        
        if let address = date.address {
            if let street = address.street {
                if street.characters.count > 0 {
                    addressLabel.text = street
                } else {
                    addressLabel.text = "Mailing Address not set"
                }
            }
            if let region = address.region {
                if region.characters.count > 0 {
                    regionLabel.text = region
                } else {
                    regionLabel.text = "City, State Zip not set"
                }
            }
        }
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["date"] as! String == String(date.objectID.URIRepresentation()) {
               reminderImage.image = UIImage(named: "reminder-on.png")?.imageWithRenderingMode(.AlwaysTemplate)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        animateDropInLabelFor(ageLabel, fromPosition: -50, delay: 0)
        animateDropInLabelFor(daysUntilLabel, fromPosition: -50, delay: 0.1)
        animateDropInLabelFor(dateLabel, fromPosition: -50, delay: 0.2)
        
        reminderImageContainerView.center.x = 450
        UIView.animateWithDuration(1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.reminderImageContainerView.center.x = self.view.center.x
            }, completion: nil)
    }
    
    @IBAction func unwindToDateDetails(segue: UIStoryboardSegue) {
        self.loadView()
    }
    
    func showNotificationView(sender: UITapGestureRecognizer) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["date"] as! String == String(date.objectID.URIRepresentation()) {
                let fireDate = notification.fireDate!
                let daysPrior = date!.date!.getDay() - fireDate.getDay()
                notificationImage.image = UIImage(named: "reminder-on.png")?.imageWithRenderingMode(.AlwaysTemplate)
                var dayString: String?
                if daysPrior == 1 {
                    dayString = "\(daysPrior) day prior"
                } else {
                    dayString = "\(daysPrior) days prior"
                }
                var timeString: String?
                if fireDate.getHour() < 13 {
                    timeString = "\(fireDate.getHour()) AM"
                } else {
                    timeString = "\(fireDate.getHour() - 12) PM"
                }
                notificationTimeLabel.text = "\(dayString!)\nat \(timeString!)"
            } else {
                notificationImage.image = UIImage(named: "reminder-off.png")?.imageWithRenderingMode(.AlwaysTemplate)
                notificationTimeLabel.text = "Not Set"
            }
            notificationImage.tintColor = UIColor.whiteColor()
        }
        notificationView.center.y = -200
        notificationView.hidden = false
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.notificationView.center.y = self.view.center.y
        }, completion: nil)
    }
    
    func animateDropInLabelFor(label: UILabel, fromPosition: CGFloat, delay: NSTimeInterval) {
        label.center.y = fromPosition
        UIView.animateWithDuration(1, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            label.center.y = 84
            }, completion: nil)
    }
    
    func configureNavBar() {
        title = date.name!.abbreviateName()
    }
    
    func styleLabels() {
        if let dateType = date.type {
            ageLabel.backgroundColor = colorForType[dateType]
            daysUntilLabel.backgroundColor = colorForType[dateType]
            dateLabel.backgroundColor = colorForType[dateType]
        }
    }
    
    @IBAction func dismissButton(sender: AnyObject) {
        UIView.animateWithDuration(0.7, delay: 0, options: [], animations: { () -> Void in
            self.notificationView.layer.opacity = 1
            }, completion: nil)
        notificationView.hidden = true
    }
    
    func configureDate() {
        let text = date!.date!.readableDate()
        dateLabel.text = text.stringByReplacingOccurrencesOfString(" ", withString: "\n")
    }
    
    func configureCountdown() {
        let numberOfDays = date.date!.daysBetween()
        if numberOfDays == 0 {
            daysUntilLabel.text = "Today"
        } else if numberOfDays == 1 {
            daysUntilLabel.text = "In \(numberOfDays)\nday"
        } else {
            daysUntilLabel.text = "In \(numberOfDays)\ndays"
        }
    }
    
    func configureAge() {
        switch date!.type! {
        case "birthday":
            if let year = date.date?.getYear() {
                if year == 1604 {
                    ageLabel.text = "Age\nN/A"
                } else {
                    ageLabel.text = "Turning\n\(date.date!.ageTurning())"
                }
            }
        case "anniversary", "holiday":
            if let year = date.date?.getYear() {
                if year == 1604 {
                    ageLabel.text = "Age\nN/A"
                } else {
                    ageLabel.text = "Year\n#\(date.date!.ageTurning())"
                }
            }
        default:
            break
        }
    }
    
// MARK: SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditDate" {
            let addDateVC = segue.destinationViewController as! AddDateVC
            addDateVC.isBeingEdited = true
            addDateVC.dateToSave = date
            addDateVC.managedContext = managedContext
        }
        if segue.identifier == "ShowNotes" {
            let notesTableVC = segue.destinationViewController as! NotesTableVC
            notesTableVC.typeColor = colorForType[date!.type!]
        }
    }
}