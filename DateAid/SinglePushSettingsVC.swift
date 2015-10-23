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
    
    let birthdayColor = UIColor.birthdayColor()
    let anniversaryColor = UIColor.anniversaryColor()
    let holidayColor = UIColor.holidayColor()
    
    let timeArray = ["12:00\nAM", "1:00\nAM", "2:00\nAM", "3:00\nAM", "4:00\nAM", "5:00\nAM", "6:00\nAM", "7:00\nAM", "8:00\nAM", "9:00\nAM", "10:00\nAM", "11:00\nAM",
                     "12:00\nPM", "1:00\nPM", "2:00\nPM", "3:00\nPM", "4:00\nPM", "5:00\nPM", "6:00\nPM", "7:00\nPM", "8:00\nPM", "9:00\nPM", "10:00\nPM", "11:00\nPM"]
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    
    @IBOutlet weak var daySlider: ValueSlider!
    @IBOutlet weak var timeSlider: ValueSlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        daySlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        timeSlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        
        populateLabelAndSliderValues()
        setColorsOfLabelsAndSliders()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        animateDropInLabelFor(dayLabel, fromPosition: -50, delay: 0)
        animateDropInLabelFor(timeLabel, fromPosition: -50, delay: 0.1)
        animateDropInLabelFor(soundLabel, fromPosition: -50, delay: 0.2)
    }
    
    func populateLabelAndSliderValues() {
        
        var notificationDidPopulateView: Bool?
        
        if let notifications = application.scheduledLocalNotifications {
            for notification in notifications {
                if let notificationID = notification.userInfo!["date"] as? String {
                    let dateObjectID = String(date.objectID.URIRepresentation())
                    if notificationID == dateObjectID {
                        if let dayOfNotification = notification.fireDate?.getDay(),
                            let hourOfNotification = notification.fireDate?.getHour(),
                            let dayOfDate = date?.date?.getDay() {
                                
                                let numberOfDays = dayOfDate - dayOfNotification
                                dayLabel.text = daysPriorString(inSlider: daySlider, forDaysPrior: numberOfDays)
                                timeLabel.text = timePriorString(inSlider: timeSlider, forHourOfDay: hourOfNotification)
                                daySlider.value = Float(numberOfDays)
                                timeSlider.value = Float(hourOfNotification)
                                
                                notificationDidPopulateView = true
                        }
                    }
                }
            }
            if notificationDidPopulateView != true { // There were no matching scheduled local notifications, so
                staticallySetLabelAndSliderValues()
            }
        } else { // There were no scheduled local notifications at all, so
            staticallySetLabelAndSliderValues()
        }
    }
    
    func daysPriorString(inSlider inSlider: ValueSlider, forDaysPrior: Int?) -> String {
        var daysPrior: Int
        let sliderValue = Int(inSlider.value)
        
        if let notificationDaysPrior = forDaysPrior { // Notification found, so
            daysPrior = notificationDaysPrior
        } else { // No notification found, so
            daysPrior = sliderValue
        }
        return daysPrior == 1 ? "\(daysPrior) day prior" : "\(daysPrior) days prior"
    }
    
    func timePriorString(inSlider inSlider: ValueSlider, forHourOfDay: Int?) -> String {
        var hourOfDay: Int
        let sliderValue = Int(round(inSlider.value))
        
        if let notificationHourOfDay = forHourOfDay { // Notification found, so
            hourOfDay = notificationHourOfDay
        } else { // No notification found, so
            hourOfDay = sliderValue
        }
        return timeArray[hourOfDay]
    }
    
    func staticallySetLabelAndSliderValues() {
        dayLabel.text = daysPriorString(inSlider: daySlider, forDaysPrior: nil)
        timeLabel.text = timePriorString(inSlider: timeSlider, forHourOfDay: nil)
        daySlider.setValues(min: 0, max: 21, value: 0)
        timeSlider.setValues(min: 0, max: 23, value: 0)
    }
    
    func setColorsOfLabelsAndSliders() {
        switch date.type! {
        case "birthday":
            dayLabel.backgroundColor = birthdayColor
            timeLabel.backgroundColor = birthdayColor
            soundLabel.backgroundColor = birthdayColor
            daySlider.setColorTo(birthdayColor)
            timeSlider.setColorTo(birthdayColor)
        case "anniversary":
            dayLabel.backgroundColor = anniversaryColor
            timeLabel.backgroundColor = anniversaryColor
            soundLabel.backgroundColor = anniversaryColor
            daySlider.setColorTo(anniversaryColor)
            timeSlider.setColorTo(anniversaryColor)
        case "holiday":
            dayLabel.backgroundColor = holidayColor
            timeLabel.backgroundColor = holidayColor
            soundLabel.backgroundColor = holidayColor
            daySlider.setColorTo(holidayColor)
            timeSlider.setColorTo(holidayColor)
        default:
            break
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
            dayLabel.text = daysPriorString(inSlider: daySlider, forDaysPrior: nil)
        case timeSlider:
            timeLabel.text = timeArray[Int(round(timeSlider.value))]
        default:
            break
        }
    }
    
    @IBAction func createNotification(sender: AnyObject) {
        if let notifications = application.scheduledLocalNotifications {
            for notification in notifications {
                if let notificationID = notification.userInfo!["date"] as? String {
                    let dateID = String(date.objectID.URIRepresentation())
                    if notificationID == dateID {
                        application.cancelLocalNotification(notification)
                    }
                }
            }
        }
        let daysBeforeValue = Int(daySlider.value)
        var timeInterval = -60 * 60 * 24 * daysBeforeValue
        let hourOfDayValue = Int(timeSlider.value)
        let secondsToAdd = 60 * 60 * hourOfDayValue
        timeInterval += secondsToAdd
        let daysBefore = date.date?.dateByAddingTimeInterval(Double(timeInterval))
        let fireDate = daysBefore?.setYear(NSDate().getYear())
        let localNotification = UILocalNotification()
        var alertString = ""
        if hourOfDayValue < 12 {
            alertString = "Good morning. "
        } else if hourOfDayValue < 18 {
            alertString = "Good afternoon. "
        } else {
            alertString = "Good evening. "
        }
        
        let numberOfDays = date.date!.daysBetween()
        if numberOfDays == 0 {
            localNotification.alertBody = alertString + "It's \(date.name!)'s birthday today"
        } else if numberOfDays == 1 {
            localNotification.alertBody = alertString + "It's \(date.name!)'s birthday in \(numberOfDays) day"
        } else {
            localNotification.alertBody = alertString + "It's \(date.name!)'s birthday in \(numberOfDays) days"
        }
        localNotification.alertAction = "Dismiss"
        localNotification.fireDate = fireDate!
        localNotification.soundName = UILocalNotificationDefaultSoundName
        let objectId = String(date.objectID.URIRepresentation())
        localNotification.userInfo = ["date": objectId]
        application.scheduleLocalNotification(localNotification)
    }
}
