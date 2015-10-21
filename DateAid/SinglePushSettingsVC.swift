//
//  SinglePushSettingsVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/18/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class SinglePushSettingsVC: UIViewController {
    
    var date: Date!
    let timeArray = ["12:00\nAM", "1:00\nAM", "2:00\nAM", "3:00\nAM", "4:00\nAM", "5:00\nAM", "6:00\nAM", "7:00\nAM", "8:00\nAM", "9:00\nAM", "10:00\nAM", "11:00\nAM",
                     "12:00\nPM", "1:00\nPM", "2:00\nPM", "3:00\nPM", "4:00\nPM", "5:00\nPM", "6:00\nPM", "7:00\nPM", "8:00\nPM", "9:00\nPM", "10:00\nPM", "11:00\nPM"]
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    
    @IBOutlet weak var daySlider: ValueSlider!
    @IBOutlet weak var timeSlider: ValueSlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayLabel.layer.cornerRadius = 47
        dayLabel.clipsToBounds = true
        timeLabel.layer.cornerRadius = 47
        timeLabel.clipsToBounds = true
        soundLabel.layer.cornerRadius = 47
        soundLabel.clipsToBounds = true
        daySlider.setValues(min: 0, max: 21, value: 0)
        timeSlider.setValues(min: 0, max: 23, value: 0)
        daySlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        timeSlider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
        dayLabel.text = "\(Int(daySlider.value)) days prior"
        timeLabel.text = timeArray[Int(round(timeSlider.value))]
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["date"] as! String == String(date.objectID.URIRepresentation()) {
                let fireDate = notification.fireDate!
                let daysPrior = date!.date!.getDay() - fireDate.getDay()
                dayLabel.text = "\(daysPrior) days prior"
                daySlider.value = Float(daysPrior)
                timeLabel.text = timeArray[fireDate.getHour()]
                timeSlider.value = Float(fireDate.getHour())
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dayLabel.center.y = -50
        timeLabel.center.y = -50
        soundLabel.center.y = -50
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.dayLabel.center.y = 84
            }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.timeLabel.center.y = 84
            }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
            self.soundLabel.center.y = 84
            }, completion: nil)
    }
    
    func valueChanged(sender: ValueSlider) {
        sender.value = round(sender.value)
        if sender == daySlider {
            dayLabel.text = "\(Int(daySlider.value)) days prior"
        } else if sender == timeSlider {
            timeLabel.text = timeArray[Int(round(timeSlider.value))]
        }
    }
    
    @IBAction func createNotification(sender: AnyObject) {
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if notification.userInfo!["date"] as! String == String(date.objectID.URIRepresentation()) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
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
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
}
