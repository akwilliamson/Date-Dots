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
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var reminderImageContainerView: UIView!
    @IBOutlet weak var reminderImage: UIImageView!
    
    @IBOutlet weak var notificationView: UIView!
    
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var notificationTimeLabel: UILabel!

    @IBOutlet weak var dismissButton: UIButton!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        styleLabels()
        configureCountdown()
        configureDate()
        configureAge()
        reminderImageContainerView.layer.cornerRadius = 33
        reminderImageContainerView.clipsToBounds = true
        reminderImageContainerView.layer.borderWidth = 2
        reminderImageContainerView.layer.borderColor = UIColor.birthdayColor().CGColor
        reminderImage.image = reminderImage.image?.imageWithRenderingMode(.AlwaysTemplate)
        reminderImage.tintColor = UIColor.birthdayColor()
        reminderImage.userInteractionEnabled = true
        notificationView.hidden = true
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
                addressLabel.text = street
            }
            if let region = address.region {
                regionLabel.text = region
            }
        }
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["date"] as! String == String(date.objectID.URIRepresentation()) {
               reminderImage.image = UIImage(named: "reminder-on.png")?.imageWithRenderingMode(.AlwaysTemplate)
            }
        }
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dateLabel.center.y = -50
        daysUntilLabel.center.y = -50
        ageLabel.center.y = -50
        reminderImageContainerView.center.x = 450
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.ageLabel.center.y = 84
        }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.daysUntilLabel.center.y = 84
        }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.dateLabel.center.y = 84
        }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.reminderImageContainerView.center.x = self.view.center.x
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
        if numberOfDays == 1 {
            daysUntilLabel.text = "In \(numberOfDays)\nday"
        } else {
            daysUntilLabel.text = "In \(numberOfDays)\ndays"
        }
    }
    
    func configureAge() {
        ageLabel.text = "Turning\n\(date.date!.ageTurning())"
    }
    
// MARK: SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditDate" {
            let addDateVC = segue.destinationViewController as! AddDateVC
            addDateVC.isBeingEdited = true
            addDateVC.dateToSave = date
            addDateVC.managedContext = managedContext
        }
    }
}