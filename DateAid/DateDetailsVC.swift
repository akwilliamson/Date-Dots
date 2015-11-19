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
    var dateObject: Date!
    var localNotificationFound: Bool?
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "custom": UIColor.customColor()]
    var reloadDatesTableDelegate: ReloadDatesTableDelegate?

// MARK: OUTLETS
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysUntilLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var envelopeImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var reminderImage: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!
    
    @IBOutlet weak var notesButton: UIButton!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("View Date Details")
        AppAnalytics.logEvent("View Date Details")
        envelopeImage.image = UIImage(named: "envelope.png")?.imageWithRenderingMode(.AlwaysTemplate)
        
        let reminderGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("editNotification:"))
        reminderGestureRecognizer.numberOfTapsRequired = 1
        reminderImage.addGestureRecognizer(reminderGestureRecognizer)
        reminderImage.userInteractionEnabled = true
        
        let addressGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("editAddress:"))
        addressGestureRecognizer.numberOfTapsRequired = 1
        envelopeImage.addGestureRecognizer(addressGestureRecognizer)
        envelopeImage.userInteractionEnabled = true
    }
    
    func setNotificationView() {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if let notificationID = notification.userInfo!["date"] as? String {
                if notificationID == String(dateObject.objectID.URIRepresentation()) {
                    reminderImage.image = UIImage(named: "reminder-on.png")?.imageWithRenderingMode(.AlwaysTemplate)
                    let daysPrior = Int(notification.userInfo!["daysPrior"] as! String)!
                    let hourOfDay = Int(notification.userInfo!["hoursAfter"] as! String)!
                    let dayText: String!
                    
                    switch daysPrior {
                    case 0:
                        dayText = "Day of "
                    case 1:
                        dayText = "\(daysPrior) day before "
                    default:
                        dayText = "\(daysPrior) days before "
                    }
                    
                    switch hourOfDay {
                    case 0:
                        reminderLabel.text = dayText + "at midnight"
                    case 1...11:
                        reminderLabel.text = dayText + "at \(hourOfDay)am"
                    case 12:
                        reminderLabel.text = dayText + "at noon"
                    default:
                        reminderLabel.text = dayText + "at \(hourOfDay - 12)pm"
                    }
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
        setNotificationView()
        configureNavBar()
        styleLabels()
        configureAge()
        configureCountdown()
        configureDate()
        if let dateType = dateObject.type {
            envelopeImage.tintColor = colorForType[dateType]
            reminderImage.tintColor = colorForType[dateType]
            reminderLabel.textColor = colorForType[dateType]
            notesButton.backgroundColor = colorForType[dateType]
        }
        
        setAddressLabelsFor(dateObject.address?.street, region: dateObject.address?.region)
        
        animateDropInLabelFor(ageLabel, fromPosition: -50, delay: 0)
        animateDropInLabelFor(daysUntilLabel, fromPosition: -50, delay: 0.1)
        animateDropInLabelFor(dateLabel, fromPosition: -50, delay: 0.2)
        reminderImage.center.x = 600
        reminderLabel.center.x = 600
        UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.reminderImage.center.x = self.view.center.x
            self.reminderLabel.center.x = self.view.center.x
            }, completion: nil)
    }
    
    func setAddressLabelsFor(street: String?, region: String?) {
        if let street = street {
            let streetText = (street.characters.count > 0) ? street : "No Address"
            addressLabel.text = streetText
            addressLabel.textColor = streetText == "No Address" ? UIColor.lightGrayColor() : UIColor.grayColor()
        }
        if let region = region {
            let regionText = (region.characters.count > 0) ? region : "No Locality"
            regionLabel.text = regionText
            regionLabel.textColor = regionText == "No Locality" ? UIColor.lightGrayColor() : UIColor.grayColor()
        }
    }
    
    func editNotification(sender: UITapGestureRecognizer) {
        Flurry.logEvent("Notification Bell Tapped")
        AppAnalytics.logEvent("Notification Bell Tapped")
        self.performSegueWithIdentifier("ShowNotification", sender: self)
    }
    
    func editAddress(sender: UITapGestureRecognizer) {
        Flurry.logEvent("Envelope Tapped")
        AppAnalytics.logEvent("Envelope Tapped")
        self.performSegueWithIdentifier("ShowAddress", sender: self)
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
        if let abbreviatedName = dateObject.name?.abbreviateName() {
            title = dateObject.type! == "birthday" ? abbreviatedName : dateObject.name!
        }
    }
    
    func styleLabels() {
        if let dateType = dateObject.type {
            ageLabel.backgroundColor = colorForType[dateType]
            daysUntilLabel.backgroundColor = colorForType[dateType]
            dateLabel.backgroundColor = colorForType[dateType]
        }
    }

    func configureDate() {
        if let readableDate = dateObject?.date?.readableDate() {
            dateLabel.text = readableDate.stringByReplacingOccurrencesOfString(" ", withString: "\n")
        }
    }
    
    func configureAge() {
        if dateObject.date!.getYear() == 1604 {
            ageLabel.text = "Age\nN/A"
        } else {
            let age: Int
            if dateObject.date?.daysBetween() == 0 {
                age = dateObject.date!.ageTurning()-1
            } else {
                age = dateObject.date!.ageTurning()
            }
            ageLabel.text = dateObject!.type! == "birthday" ? "Turning\n\(age)" : "Year\n#\(age)"
        }
    }
    
    func configureCountdown() {
        if let numberOfDays = dateObject.date?.daysBetween() {
            if numberOfDays == 0 {
                daysUntilLabel.text = "Today"
            } else if numberOfDays == 1 {
                daysUntilLabel.text = "In \(numberOfDays)\nday"
            } else {
                daysUntilLabel.text = "In \(numberOfDays)\ndays"
            }
        }
    }
    
// MARK: SEGUE
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditDate" {
            let addDateVC = segue.destinationViewController as! AddDateVC
            addDateVC.isBeingEdited = true
            addDateVC.dateToSave = dateObject
            addDateVC.managedContext = managedContext
            addDateVC.notificationDelegate = self
            addDateVC.reloadDatesTableDelegate = reloadDatesTableDelegate
        }
        if segue.identifier == "ShowNotes" {
            let notesTableVC = segue.destinationViewController as! NotesTableVC
            notesTableVC.managedContext = managedContext
            notesTableVC.typeColor = colorForType[dateObject!.type!]
            notesTableVC.date = dateObject
        }
        if segue.identifier == "ShowNotification" {
            let singlePushSettingsVC = segue.destinationViewController as! SinglePushSettingsVC
            singlePushSettingsVC.dateObject = dateObject
            singlePushSettingsVC.notificationDelegate = self
        }
        if segue.identifier == "ShowAddress" {
            let editDetailsVC = segue.destinationViewController as! EditDetailsVC
            editDetailsVC.dateObject = dateObject
            editDetailsVC.managedContext = managedContext
            editDetailsVC.addressDelegate = self
            editDetailsVC.reloadDatesTableDelegate = reloadDatesTableDelegate
        }
    }
}

extension DateDetailsVC: SetNotificationDelegate {
    
    func reloadNotificationView() {
        self.localNotificationFound = false
    }
}

extension DateDetailsVC: SetAddressDelegate {

    func setAddressProperties(street: String?, region: String?) {
        setAddressLabelsFor(street, region: region)
    }
    
}


