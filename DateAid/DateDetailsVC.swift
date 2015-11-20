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
    
    @IBOutlet weak var ageLabel: CircleLabel!
    @IBOutlet weak var daysUntilLabel: CircleLabel!
    @IBOutlet weak var dateLabel: CircleLabel!
    
    @IBOutlet weak var envelopeImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
    @IBOutlet weak var reminderImage: SlideImageView!
    @IBOutlet weak var reminderLabel: SlideLabel!
    
    @IBOutlet weak var notesButton: UIButton!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logEvents(forString: "View Date Details")

        envelopeImage.image = UIImage(named: "envelope.png")?.imageWithRenderingMode(.AlwaysTemplate)
        
        self.addTapGestureRecognizer(onImageView: reminderImage, forAction: "editNotification:")
        self.addTapGestureRecognizer(onImageView: envelopeImage, forAction: "editAddress:")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setColorTheme(forType: dateObject.type)
        setNotificationView()
        populateViews()
        animateViews()
    }
    
    func addTapGestureRecognizer(onImageView imageView: UIImageView, forAction action: String) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(action))
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func populateViews() {
        populateNavBarTitle(forDate: dateObject)
        
        populateAgeLabel(forDate: dateObject)
        populateDaysUntilLabel(forDate: dateObject)
        populateDateLabel(forDate: dateObject)
        
        populateAddressLabels(forDate: dateObject)
    }
    
    func animateViews() {
        ageLabel.animateDropIn(withDelay: 0)
        daysUntilLabel.animateDropIn(withDelay: 0.1)
        dateLabel.animateDropIn(withDelay: 0.2)
        
        reminderImage.animateSlideIn(withDuration: 0.5, toPosition: view.center.x)
        reminderLabel.animateSlideIn(withDuration: 0.5, toPosition: view.center.x)
    }
    
    func textForDaysPrior(daysPrior: Int) -> String {
        switch daysPrior {
        case 0:
            return "Day of "
        case 1:
            return "\(daysPrior) day before "
        default:
            return "\(daysPrior) days before "
        }
    }
    
    func textForHourOfDay(hourOfDay: Int) -> String {
        switch hourOfDay {
        case 0:
            return "at midnight"
        case 1...11:
            return "at \(hourOfDay)am"
        case 12:
            return "at noon"
        default:
            return "at \(hourOfDay - 12)pm"
        }
    }
    
    func setNotificationView() {
        guard let notifications = UIApplication.sharedApplication().scheduledLocalNotifications else { return }
        for notification in notifications {
            
            guard let notificationID = notification.userInfo!["date"] as? String else { return }
            let dateObjectURL = String(dateObject.objectID.URIRepresentation())
            
            if notificationID == dateObjectURL {
                localNotificationFound = true
                
                guard let daysPrior = Int(notification.userInfo?["daysPrior"] as! String) else { return }
                guard let hourOfDay = Int(notification.userInfo?["hoursAfter"] as! String) else { return }
                
                let daysPriorText = self.textForDaysPrior(daysPrior)
                let hourOfDayText = self.textForHourOfDay(hourOfDay)
                
                setReminderTextAndImage(toImage: "reminder-on.png", withText: daysPriorText + hourOfDayText)
            }
        }
        if localNotificationFound != true {
            setReminderTextAndImage(toImage: "reminder-off.png", withText: "Alert Not Set")
        }
    }
    
    func setReminderTextAndImage(toImage imageString: String, withText text: String) {
        reminderLabel.text = text
        reminderImage.image = UIImage(named: imageString)?.imageWithRenderingMode(.AlwaysTemplate)
    }
    
    func populateAddressLabels(forDate date: Date) {
        if let address = date.address {
            self.populateAddressText(forLabel: addressLabel, withText: address.street)
            self.populateAddressText(forLabel: regionLabel, withText: address.region)
        }
    }
    
    func populateAddressText(forLabel label: UILabel, withText text: String?) {
        if let text = text {
            label.text = text
            label.textColor = UIColor.grayColor()
        } else {
            label.textColor = UIColor.lightGrayColor()
        }
    }
    
    func editNotification(sender: UITapGestureRecognizer) {
        self.logEvents(forString: "Notification Bell Tapped")
        self.performSegueWithIdentifier("ShowNotification", sender: self)
    }
    
    func editAddress(sender: UITapGestureRecognizer) {
        self.logEvents(forString: "Envelope Tapped")
        self.performSegueWithIdentifier("ShowAddress", sender: self)
    }
    
    @IBAction func unwindToDateDetails(segue: UIStoryboardSegue) {
        self.loadView()
    }
    
    func populateNavBarTitle(forDate date: Date) {
        if let abbreviatedName = date.name?.abbreviateName() {
            title = date.type! == "birthday" ? abbreviatedName : dateObject.name!
        }
    }
    
    func setColorTheme(forType type: String?) {
        if let type = type {
            [dateLabel, daysUntilLabel, ageLabel].forEach({ $0.backgroundColor = colorForType[type] })
            [envelopeImage, reminderImage].forEach({ $0.tintColor = colorForType[type] })
            reminderLabel.textColor = colorForType[type]
            notesButton.backgroundColor = colorForType[type]
        }
    }

    func populateDateLabel(forDate date: Date) {
        if let readableDate = date.date?.readableDate() {
            dateLabel.text = readableDate.stringByReplacingOccurrencesOfString(" ", withString: "\n")
        }
    }
    
    func populateAgeLabel(forDate date: Date) {
        if date.date!.getYear() == 1604 {
            ageLabel.text = "Age\nN/A"
        } else {
            let age: Int
            if date.date?.daysBetween() == 0 {
                age = date.date!.ageTurning()-1
            } else {
                age = date.date!.ageTurning()
            }
            ageLabel.text = date.type! == "birthday" ? "Turning\n\(age)" : "Year\n#\(age)"
        }
    }
    
    func populateDaysUntilLabel(forDate date: Date) {
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

    func repopulateAddressFor(dateObject date: Date) {
        populateAddressLabels(forDate: dateObject)
    }
    
}
