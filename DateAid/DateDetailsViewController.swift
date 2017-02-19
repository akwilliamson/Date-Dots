//
//  DateDetailsViewController.swift
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

class DateDetailsViewController: UIViewController {
    
// MARK: PROPERTIES

    var managedContext: NSManagedObjectContext?
    var dateObject: Date!
    var localNotificationFound: Bool?
    let colorForType = ["birthday": UIColor.birthday, "anniversary": UIColor.anniversary, "custom": UIColor.custom]

// MARK: OUTLETS
    
    @IBOutlet weak var ageLabel: CircleLabel!
    @IBOutlet weak var daysUntilLabel: CircleLabel!
    @IBOutlet weak var dateLabel: CircleLabel!
    
    @IBOutlet weak var leftDecorationImage: UIImageView!
    @IBOutlet weak var rightDecorationImage: UIImageView!
    
    @IBOutlet weak var envelopeImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    
    @IBOutlet weak var reminderImage: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!
    
    @IBOutlet weak var notesButton: UIButton!
    
// MARK: VIEW SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logEvents(forString: "View Date Details")
        addGestureRecognizers()
        envelopeImage.image = UIImage(named: "envelope.png")?.withRenderingMode(.alwaysTemplate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setColorTheme(to: dateObject.color)
        setdecorationImages(for: dateObject.dateType)
        populateDateViews()
        populateAlertViews()
        animateViews()
    }
    
    func addGestureRecognizers() {
        [envelopeImage, addressLabel, regionLabel].forEach({ addTapGesture(to: $0, action: "showAddress:") })
        [reminderImage, reminderLabel].forEach({ addTapGesture(to: $0, action: "showNotification:") })
    }
    
    func addTapGesture(to view: UIView, action: String) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(action))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setColorTheme(to color: UIColor) {
        [dateLabel, daysUntilLabel, ageLabel].forEach({ $0.backgroundColor = color })
        [envelopeImage, reminderImage].forEach({ $0.tintColor = color })
        reminderLabel.textColor = color
        notesButton.backgroundColor = color
    }
    
    func setdecorationImages(for dateType: DateType) {
        [leftDecorationImage, rightDecorationImage].forEach({ $0.image = dateType.decorationImage })
    }
    
    func populateDateViews() {
        title = dateObject.abbreviatedName
        populateAgeLabel(for: dateObject)
        populateDaysUntilLabel(for: dateObject)
        populateDateLabel(for: dateObject)
        populateAddressLabels(for: dateObject)
    }
    
    func populateAgeLabel(for date: Date) {
        guard let age = date.date?.ageTurning else { ageLabel.text = "?"; return }
        ageLabel.text = date.type! == "Birthday" ? "\(age)" : "#\(age)"
    }
    
    func populateDaysUntilLabel(for date: Date) {
        guard let daysUntil = date.date?.daysUntil else { return }

        if daysUntil == 0 {
            daysUntilLabel.text = "Today"
        } else if daysUntil == 1 {
            daysUntilLabel.text = "In \(daysUntil)\nday"
        } else {
            daysUntilLabel.text = "In \(daysUntil)\ndays"
        }
    }
    
    func populateDateLabel(for date: Date) {
        if let readableDate = date.date?.formatted("MMM dd") {
            dateLabel.text = readableDate.replacingOccurrences(of: " ", with: "\n")
        }
    }
    
    func populateAddressLabels(for date: Date) {
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
    
    func showNotification(_ sender: UITapGestureRecognizer) {
        self.logEvents(forString: "Notification Gesture Tapped")
        self.performSegue(withIdentifier: "ShowNotification", sender: self)
    }
    
    func showAddress(_ sender: UITapGestureRecognizer) {
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
        }
    }
}

extension DateDetailsViewController: SetNotificationDelegate {
    
    func reloadNotificationView() {
        self.localNotificationFound = false
    }
}

extension DateDetailsViewController: SetAddressDelegate {

    func repopulateAddressFor(dateObject date: Date) {
        populateAddressLabels(for: dateObject)
    }
}
