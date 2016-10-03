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
    
    @IBOutlet weak var reminderImage: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!
    
    @IBOutlet weak var notesButton: UIButton!
    
    @IBOutlet weak var leftDecorationImage: UIImageView!
    @IBOutlet weak var rightDecorationImage: UIImageView!
    
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logEvents(forString: "View Date Details")
        self.addGestureRecognizers()

        envelopeImage.image = UIImage(named: "envelope.png")?.withRenderingMode(.alwaysTemplate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setColorTheme(forType: dateObject.type)
        setdecorationImages(forType: dateObject.type)
        populateDateViews()
        populateAlertViews()
        animateViews()
    }
    
    func addGestureRecognizers() {
        self.addTapGestureRecognizer(onView: envelopeImage, forAction: "segueToAddress:")
        self.addTapGestureRecognizer(onView: addressLabel, forAction: "segueToAddress:")
        self.addTapGestureRecognizer(onView: regionLabel, forAction: "segueToAddress:")
        self.addTapGestureRecognizer(onView: reminderImage, forAction: "segueToNotification:")
        self.addTapGestureRecognizer(onView: reminderLabel, forAction: "segueToNotification:")
    }
    
    func addTapGestureRecognizer(onView view: UIView, forAction action: String) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(action))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setColorTheme(forType dateType: String?) {
        if let dateType = dateType {
            [dateLabel, daysUntilLabel, ageLabel].forEach({ $0.backgroundColor = colorForType[dateType] })
            [envelopeImage, reminderImage].forEach({ $0.tintColor = colorForType[dateType] })
            reminderLabel.textColor = colorForType[dateType]
            notesButton.backgroundColor = colorForType[dateType]
        }
    }
    
    func setdecorationImages(forType dateType: String?) {
        guard let dateType = dateType else { return }
        switch dateType {
        case "birthday":
            [leftDecorationImage, rightDecorationImage].forEach({ $0.image = UIImage(named: "balloon.png") })
        case "anniversary":
            [leftDecorationImage, rightDecorationImage].forEach({ $0.image = UIImage(named: "heart.png") })
        case "custom":
            [leftDecorationImage, rightDecorationImage].forEach({ $0.image = UIImage(named: "calendar.png") })
        default:
            break
        }
    }
    
    func populateDateViews() {
        populateNavBarTitle(forDate: dateObject)
        
        populateAgeLabel(forDate: dateObject)
        populateDaysUntilLabel(forDate: dateObject)
        populateDateLabel(forDate: dateObject)
        
        populateAddressLabels(forDate: dateObject)
    }
    
    
    func populateNavBarTitle(forDate date: Date) {
        if let abbreviatedName = date.name?.abbreviatedName() {
            title = date.type! == "birthday" ? abbreviatedName : dateObject.name!
        }
    }
    
    func populateAgeLabel(forDate date: Date) {
        if date.date!.getYear() == 1604 {
            ageLabel.text = "?"
        } else {
            let age: Int
            if date.date?.daysBetween() == 0 {
                age = date.date!.ageTurning()-1
            } else {
                age = date.date!.ageTurning()
            }
            ageLabel.text = date.type! == "birthday" ? "\(age)" : "#\(age)"
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
    
    func populateDateLabel(forDate date: Date) {
        if let readableDate = date.date?.readableDate() {
            dateLabel.text = readableDate.replacingOccurrences(of: " ", with: "\n")
        }
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
            label.textColor = UIColor.gray
        } else {
            label.textColor = UIColor.lightGray
        }
    }
    
    func populateAlertViews() {
        guard let notifications = UIApplication.shared.scheduledLocalNotifications else { return }
        
        for notification in notifications {
            guard let notificationID = notification.userInfo!["date"] as? String else { return }
            let dateObjectURL = String(describing: dateObject.objectID.uriRepresentation())
            
            if notificationID == dateObjectURL {
                localNotificationFound = true
                
                guard let daysPrior = Int(notification.userInfo?["daysPrior"] as! String) else { return }
                guard let hourOfDay = Int(notification.userInfo?["hoursAfter"] as! String) else { return }
                
                let daysPriorText = self.textForDaysPrior(daysPrior)
                let hourOfDayText = self.textForHourOfDay(hourOfDay)
                
                self.setAlertTextAndImage(toImage: "reminder-on.png", withText: daysPriorText + hourOfDayText)
            }
        }
        if localNotificationFound != true {
            self.setAlertTextAndImage(toImage: "reminder-off.png", withText: "Alert Not Set")
        }
    }
    
    func textForDaysPrior(_ daysPrior: Int) -> String {
        switch daysPrior {
        case 0:
            return "Day of "
        case 1:
            return "\(daysPrior) day before "
        default:
            return "\(daysPrior) days before "
        }
    }
    
    func textForHourOfDay(_ hourOfDay: Int) -> String {
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
    
    func setAlertTextAndImage(toImage imageString: String, withText text: String) {
        reminderLabel.text = text
        reminderImage.image = UIImage(named: imageString)?.withRenderingMode(.alwaysTemplate)
    }
    
    func animateViews() {
        ageLabel.animateDropIn(withDelay: 0)
        daysUntilLabel.animateDropIn(withDelay: 0.1)
        dateLabel.animateDropIn(withDelay: 0.2)
        
        reminderImage.animateSlideIn(withDuration: 0.5, toPosition: view.center.x)
        reminderLabel.animateSlideIn(withDuration: 0.5, toPosition: view.center.x)
    }
    
    func segueToNotification(_ sender: UITapGestureRecognizer) {
        self.logEvents(forString: "Notification Gesture Tapped")
        self.performSegue(withIdentifier: "ShowNotification", sender: self)
    }
    
    func segueToAddress(_ sender: UITapGestureRecognizer) {
        self.logEvents(forString: "Address Gesture Tapped")
        self.performSegue(withIdentifier: "ShowAddress", sender: self)
    }
    
// MARK: SEGUE
    
    @IBAction func unwindToDateDetails(_ segue: UIStoryboardSegue) {
        self.loadView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDate" {
            let addDateVC = segue.destination as! AddDateVC
            addDateVC.isBeingEdited = true
            addDateVC.dateToSave = dateObject
            addDateVC.managedContext = managedContext
            addDateVC.notificationDelegate = self
            addDateVC.reloadDatesTableDelegate = reloadDatesTableDelegate
        }
        if segue.identifier == "ShowNotes" {
            let notesTableVC = segue.destination as! NotesTableVC
            notesTableVC.managedContext = managedContext
            notesTableVC.typeColor = colorForType[dateObject!.type!]
            notesTableVC.dateObject = dateObject
        }
        if segue.identifier == "ShowNotification" {
            let singlePushSettingsVC = segue.destination as! SinglePushSettingsVC
            singlePushSettingsVC.dateObject = dateObject
            singlePushSettingsVC.notificationDelegate = self
        }
        if segue.identifier == "ShowAddress" {
            let editDetailsVC = segue.destination as! EditDetailsVC
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
