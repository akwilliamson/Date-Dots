//
//  SinglePushSettingsVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/18/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class SinglePushSettingsVC: UIViewController {
    
    let application = UIApplication.sharedApplication()
    var date: Date!
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "holiday": UIColor.holidayColor()]
    let timeArray = ["12:00\nAM", "1:00\nAM", "2:00\nAM", "3:00\nAM", "4:00\nAM", "5:00\nAM", "6:00\nAM", "7:00\nAM", "8:00\nAM", "9:00\nAM", "10:00\nAM", "11:00\nAM",
                     "12:00\nPM", "1:00\nPM", "2:00\nPM", "3:00\nPM", "4:00\nPM", "5:00\nPM", "6:00\nPM", "7:00\nPM", "8:00\nPM", "9:00\nPM", "10:00\nPM", "11:00\nPM"]
    
    var previouslyScheduledNotification: UILocalNotification?
    var alertPrefix: String?
    var alertSuffix: String?
    var alertDaysBefore: Double?
    var alertHourOfDay: Double?
    var daysBeforeUserInfo: String?
    var hoursAfterUserInfo: String?
    var notificationDelegate: SetNotificationDelegate?
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var daySlider: ValueSlider!
    @IBOutlet weak var timeSlider: ValueSlider!
    
    @IBOutlet weak var trashIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        application.registerUserNotificationSettings(localNotificationSettings)
        
        daySlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        timeSlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        
        let repeatRecognizer = UITapGestureRecognizer(target: self, action: Selector("editRepeat:"))
        repeatRecognizer.numberOfTapsRequired = 1
        repeatLabel.addGestureRecognizer(repeatRecognizer)
        repeatLabel.userInteractionEnabled = true
        
        let trashRecognizer = UITapGestureRecognizer(target: self, action: Selector("deleteNotification:"))
        trashRecognizer.numberOfTapsRequired = 1
        trashIcon.addGestureRecognizer(trashRecognizer)
        trashIcon.userInteractionEnabled = true
        
        populateLabelAndSliderValues()
        setColorsOfLabelsAndSliders()
        setAlertBodySuffix(daySlider.value)
        setAlertBodyPrefix(timeSlider.value)
        setAlertDaysBeforeInSeconds(daySlider.value)
        setAlertHourOfDayInSeconds(timeSlider.value)
    }
    
    override func viewDidLayoutSubviews() {
        addLabelsToSliders([daySlider,timeSlider])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        animateDropInLabelFor(dayLabel, fromPosition: -50, delay: 0)
        animateDropInLabelFor(timeLabel, fromPosition: -50, delay: 0.1)
        animateDropInLabelFor(repeatLabel, fromPosition: -50, delay: 0.2)
    }
    
    func populateLabelAndSliderValues() {
        
        if let notifications = application.scheduledLocalNotifications {
            for notification in notifications {
                if let notificationID = notification.userInfo!["date"] as? String {
                    let dateObjectID = String(date.objectID.URIRepresentation())
                    if notificationID == dateObjectID {
                        let daysPrior = Int(notification.userInfo!["daysPrior"] as! String)!
                        let hoursAfter = Int(notification.userInfo!["hoursAfter"] as! String)!
                        dayLabel.text = daysPriorString(inSlider: daySlider, forDaysPrior: daysPrior)
                        daySlider.setValues(min: 0, max: 31, value: Float(daysPrior))
                        timeLabel.text = timePriorString(inSlider: timeSlider, forHourOfDay: hoursAfter)
                        timeSlider.setValues(min: 0, max: 23, value: Float(hoursAfter))
                        if notification.repeatInterval == .Year {
                            repeatLabel.text = "Yearly"
                        } else {
                            repeatLabel.text = "Once"
                        }
                        previouslyScheduledNotification = notification
                    }
                }
            }
            if previouslyScheduledNotification == nil { // There were no matching scheduled local notification, so
                trashIcon.hidden = true
                staticallySetLabelAndSliderValues()
            }
        } else { // There were no scheduled local notifications at all, so
            trashIcon.hidden = true
            staticallySetLabelAndSliderValues()
        }
    }
    
    func staticallySetLabelAndSliderValues() {
        dayLabel.text = daysPriorString(inSlider: daySlider, forDaysPrior: nil)
        timeLabel.text = timePriorString(inSlider: timeSlider, forHourOfDay: nil)
        repeatLabel.text = "Yearly"
        daySlider.setValues(min: 0, max: 21, value: 0)
        timeSlider.setValues(min: 0, max: 23, value: 0)
    }
    
    func setColorsOfLabelsAndSliders() {
        if let dateType = date.type {
            dayLabel.backgroundColor = colorForType[dateType]
            timeLabel.backgroundColor = colorForType[dateType]
            repeatLabel.backgroundColor = colorForType[dateType]
            daySlider.setColorTo(colorForType[dateType]!)
            timeSlider.setColorTo(colorForType[dateType]!)
        }
    }
    
    func setAlertBodyPrefix(hourOfDayValue: Float) {
        if Int(hourOfDayValue) < 12 {
            alertPrefix = "Good morning. "
        } else if Int(hourOfDayValue) < 18 {
            alertPrefix = "Good afternoon. "
        } else {
            alertPrefix = "Good evening. "
        }
    }
    
    func setAlertBodySuffix(daysBefore: Float) {
        if daysBefore == 0 {
            alertSuffix = "It's \(date.name!)'s birthday today"
        } else if daysBefore == 1 {
            alertSuffix = "It's \(date.name!)'s birthday in 1 day"
        } else {
            alertSuffix = "It's \(date.name!)'s birthday in \(daysBefore) days"
        }
    }
    
    func animateDropInLabelFor(label: UILabel, fromPosition: CGFloat, delay: NSTimeInterval) {
        label.center.y = fromPosition
        UIView.animateWithDuration(1, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            label.center.y = 84
        }, completion: nil)
    }
    
    func valueChanged(sender: ValueSlider) {
        switch sender {
        case daySlider:
            dayLabel.text = daysPriorString(inSlider: sender, forDaysPrior: nil)
            setAlertBodySuffix(sender.value)
            daysBeforeUserInfo = String(Int(floor(sender.value)))
            setAlertDaysBeforeInSeconds(sender.value)
        case timeSlider:
            timeLabel.text = timePriorString(inSlider: sender, forHourOfDay: nil)
            setAlertBodyPrefix(sender.value)
            hoursAfterUserInfo = String(Int(floor(sender.value)))
            setAlertHourOfDayInSeconds(sender.value)
        default:
            break
        }
    }
    
    func setAlertDaysBeforeInSeconds(daysBefore: Float) {
        let daysBeforeValue = Int(daysBefore)
        daysBeforeUserInfo = String(Int(floor(daysBefore)))
        alertDaysBefore = Double(-60 * 60 * 24 * daysBeforeValue)
    }
    
    func setAlertHourOfDayInSeconds(hourOfDay: Float) {
        let hourOfDayValue = Int(floor(hourOfDay))
        hoursAfterUserInfo = String(Int(floor(hourOfDay)))
        alertHourOfDay = Double(60 * 60 * hourOfDayValue)
    }
    
    func daysPriorString(inSlider inSlider: ValueSlider, forDaysPrior: Int?) -> String {
        var daysPrior: Int
        let sliderValue = Int(inSlider.value)
        
        if let notificationDaysPrior = forDaysPrior { // Notification found, so
            daysPrior = notificationDaysPrior
        } else { // No notification found, so
            daysPrior = sliderValue
        }
        switch daysPrior {
        case 0:
            return "Day of"
        case 1:
            return "\(daysPrior) day prior"
        default:
            return "\(daysPrior) days prior"
        }
    }
    
    func timePriorString(inSlider inSlider: ValueSlider, forHourOfDay: Int?) -> String {
        var hourOfDay: Int
        let sliderValue = Int(inSlider.value)
        
        if let notificationHourOfDay = forHourOfDay { // Notification found, so
            hourOfDay = notificationHourOfDay
        } else { // No notification found, so
            hourOfDay = sliderValue
        }
        return timeArray[hourOfDay]
    }
    
    func addLabelsToSliders(sliders: [ValueSlider]) {
        for slider in sliders {
            let thumbView = slider.subviews.last
            if thumbView?.viewWithTag(1) == nil {
                let label = UILabel(frame: thumbView!.bounds)
                label.backgroundColor = UIColor.clearColor()
                label.textAlignment = .Center
                label.textColor = UIColor.whiteColor()
                label.tag = 1
                switch slider {
                case daySlider:
                    label.text = "D"
                case timeSlider:
                    label.text = "H"
                default:
                    break
                }
                thumbView?.addSubview(label)
            }
        }
    }
    
    func editRepeat(sender: UITapGestureRecognizer) {
        switch repeatLabel.text! {
        case "Yearly":
            repeatLabel.text = "Once"
        case "Once":
            repeatLabel.text = "Yearly"
        default:
            break
        }
    }
    
    func cancelExistingNotification() {
        if let notification = previouslyScheduledNotification {
            application.cancelLocalNotification(notification)
        }
    }
    
    func deleteNotification(sender: UITapGestureRecognizer) {
        cancelExistingNotification()
        notificationDelegate?.reloadNotificationView() 
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func createNotification(sender: AnyObject) {
        
        cancelExistingNotification()
        
        let setSecondsBefore = alertDaysBefore! + alertHourOfDay!
        let fireMonthAndDay = date.date?.dateByAddingTimeInterval(setSecondsBefore)
        let dateID = String(date.objectID.URIRepresentation())
        
        let fireDate = fireMonthAndDay!.setYear(NSDate().getYear())
        let alertBody = alertPrefix! + alertSuffix!
        let alertAction = "Dismiss"
        let soundName = UILocalNotificationDefaultSoundName
        let userInfo = ["date": dateID, "daysPrior": daysBeforeUserInfo!, "hoursAfter": hoursAfterUserInfo!]
        let repeatInterval: NSCalendarUnit?
        if repeatLabel.text == "Yearly" {
            repeatInterval = .Year
        } else {
            repeatInterval = nil
        }
        let localNotification = LocalNotification(fireDate: fireDate, repeatInterval: repeatInterval, alertBody: alertBody, alertAction: alertAction, soundName: soundName, userInfo: userInfo)
        localNotification.schedule()
        
        notificationDelegate?.reloadNotificationView()
        self.navigationController?.popViewControllerAnimated(true)
    }
}
