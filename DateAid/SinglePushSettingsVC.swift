//
//  SinglePushSettingsVC.swift
//  DateAid
//
//  Created by Aaron Williamson on 10/18/15.
//  Copyright © 2015 Aaron Williamson. All rights reserved.
//

import UIKit

class SinglePushSettingsVC: UIViewController {
    
    var dateObject: Date!
    var notificationDelegate: SetNotificationDelegate?
    
    let application = UIApplication.sharedApplication()
    let colorForType = ["birthday": UIColor.birthdayColor(), "anniversary": UIColor.anniversaryColor(), "custom": UIColor.customColor()]
    let timeArray = ["12:00\nAM", "1:00\nAM", "2:00\nAM", "3:00\nAM", "4:00\nAM", "5:00\nAM", "6:00\nAM", "7:00\nAM", "8:00\nAM", "9:00\nAM", "10:00\nAM", "11:00\nAM",
                     "12:00\nPM", "1:00\nPM", "2:00\nPM", "3:00\nPM", "4:00\nPM", "5:00\nPM", "6:00\nPM", "7:00\nPM", "8:00\nPM", "9:00\nPM", "10:00\nPM", "11:00\nPM"]
    
    var previouslyScheduledNotification: UILocalNotification?
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var daySlider: ValueSlider!
    @IBOutlet weak var timeSlider: ValueSlider!
    
    @IBOutlet weak var trashIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("Push Notification Setting")
        checkIfUserHasEnabledLocalNotifications()
        
        addValueChangedTargetOn([daySlider, timeSlider])
        addSingleTapGestureRecognizerOn([repeatLabel, trashIcon], forActions: ["toggleRepeat", "deletePreviousNotification"])
        
        setLabelAndSliderValues()
        setLabelAndSliderColors()
        
    }
    
    override func viewDidLayoutSubviews() {
        addLabelOnThumbForSliders()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        animateDropInFor([dayLabel, timeLabel, repeatLabel], withDelays: [0, 0.1, 0.2])
    }
    
    func checkIfUserHasEnabledLocalNotifications() {
        let localNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        application.registerUserNotificationSettings(localNotificationSettings)
    }
    
    func addValueChangedTargetOn(sliders: [ValueSlider]) {
        sliders.forEach { $0.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged) }
    }
    
    func addSingleTapGestureRecognizerOn(views: [UIView], forActions: [String]) {
        for (index, view) in views.enumerate() {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(forActions[index]))
            gestureRecognizer.numberOfTapsRequired = 1
            view.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    func setLabelAndSliderValues() {
        let allLocalNotifications = application.scheduledLocalNotifications
        
        allLocalNotifications?.forEach({
            if $0.userInfo!["date"] as? String == String(dateObject.objectID.URIRepresentation()) { // There was a scheduled notification for incoming date so,
                setLabelAndSliderValues(viaNotification: $0)
                previouslyScheduledNotification = $0
            }
        })
        if previouslyScheduledNotification == nil { // There were no matching scheduled local notification, so
            setLabelAndSliderValues(viaNotification: nil)
            trashIcon.hidden = true
        }
    }
    
    func setLabelAndSliderValues(viaNotification notification: UILocalNotification?) {
        if let notification = notification {
            let notificationDaysPrior = Float(notification.userInfo!["daysPrior"] as! String)!
            let notificationHourOfDay = Float(notification.userInfo!["hoursAfter"] as! String)!
            setLabelValues(forDaysPrior: notificationDaysPrior, at: notificationHourOfDay)
            setSliderValues(forDaysPrior: notificationDaysPrior, at: notificationHourOfDay)
            repeatLabel.text = notification.repeatInterval == .Year ? "Yearly" : "Once"
        } else {
            setLabelValues(forDaysPrior: 0, at: 0)
            setSliderValues(forDaysPrior: 0, at: 0)
            repeatLabel.text = "Yearly"
        }
    }
    
    func setLabelValues(forDaysPrior daysPrior: Float, at hourOfDay: Float) {
        dayLabel.text = setDayLabelString(forDaysPrior: daysPrior)
        timeLabel.text = setTimeLabelString(forHourOfDay: hourOfDay)
    }
    
    func setSliderValues(forDaysPrior daysPrior: Float, at hourOfDay: Float) {
        daySlider.setValues(max: 21, value: daysPrior)
        timeSlider.setValues(max: 23, value: hourOfDay)
    }
    
    func setDayLabelString(forDaysPrior forDaysPrior: Float) -> String {
        let daysPrior = Int(forDaysPrior)
        switch daysPrior {
        case 0:
            return "Day of"
        case 1:
            return "\(daysPrior) day prior"
        default:
            return "\(daysPrior) days prior"
        }
    }
    
    func setTimeLabelString(forHourOfDay hourOfDay: Float) -> String {
        let hourOfDay = Int(hourOfDay)
        return timeArray[hourOfDay]
    }
    
    func setLabelAndSliderColors() {
        if let color = colorForType[dateObject!.type!] {
            [dayLabel, timeLabel, repeatLabel].forEach { $0.backgroundColor = color }
            [daySlider, timeSlider].forEach() { $0.setColorTo(color) }
            trashIcon.tintColor = color
        }
    }
    
    func setAlertGreeting(forHourOfDay hourOfDay: Float) -> String {
        var alertPrefix = "Good "
        if Int(hourOfDay) < 12 {
            alertPrefix.appendContentsOf("morning. ")
        } else if Int(hourOfDay) < 18 {
            alertPrefix.appendContentsOf(" afternoon. ")
        } else {
            alertPrefix.appendContentsOf("evening. ")
        }
        return alertPrefix
    }
    
    func setAlertMessage(forCountdown daysBefore: Float) -> String {
        var alertSuffix = "It's \(dateObject!.name!)'s birthday "
        if daysBefore == 0 {
            alertSuffix.appendContentsOf("today")
        } else if daysBefore == 1 {
            alertSuffix.appendContentsOf("in 1 day")
        } else {
            alertSuffix.appendContentsOf("\(daysBefore) days")
        }
        return alertSuffix
    }
    
    func animateDropInFor(labels: [UILabel], withDelays delays: [NSTimeInterval]) {
        for (index, label) in labels.enumerate() {
            label.center.y = -50
            UIView.animateWithDuration(1, delay: delays[index], usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
                label.center.y = 84
                }, completion: nil)
        }
    }
    
    
    func addLabelOnThumbForSliders() {
        daySlider.addLabel("day")
        timeSlider.addLabel("time")
    }
    
    func toggleRepeat() {
        switch repeatLabel.text! {
        case "Yearly":
            repeatLabel.text = "Once"
        case "Once":
            repeatLabel.text = "Yearly"
        default:
            break
        }
    }
    
    func deletePreviousNotification() {
        if let notification = previouslyScheduledNotification {
            application.cancelLocalNotification(notification)
        }
        notificationDelegate?.reloadNotificationView()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setAlertBody() -> String {
        let greeting = setAlertGreeting(forHourOfDay: timeSlider.value)
        let message = setAlertMessage(forCountdown: daySlider.value)
        return greeting + message
    }
    
    func valueChanged(sender: ValueSlider) {
        setLabelValues(forDaysPrior: daySlider.value, at: timeSlider.value)
    }
    
    func secondsBeforeForDaysBefore() -> Double {
        return Double(-60 * 60 * 24 * daySlider.integerValue())
    }
    
    func secondsForHourOfDay() -> Double {
        return Double(60 * 60 * timeSlider.integerValue())
    }
    
    func setFireDate() -> NSDate {
        let inSeconds = secondsBeforeForDaysBefore() + secondsForHourOfDay()
        let fireMonthAndDay = dateObject.date?.dateByAddingTimeInterval(inSeconds)
        return fireMonthAndDay!.setYear(NSDate().getYear()) // Is this right? e.g. for a birthday that's already passed should I be passing in the next year?
    }
    
    @IBAction func createNotification(sender: AnyObject) {
        Flurry.logEvent("Create Notification")
        
        deletePreviousNotification()
        
        let notification = UILocalNotification()
        let fireDate = setFireDate()
        let alertBody = setAlertBody()
        let alertAction = "Dismiss"
        let soundName = UILocalNotificationDefaultSoundName
        let userInfo = ["date": String(dateObject.objectID.URIRepresentation()), "daysPrior": String(daySlider.integerValue()), "hoursAfter": String(timeSlider.integerValue())]
        let repeatInterval: NSCalendarUnit? = repeatLabel.text == "Yearly" ? .Year : nil

        notification.fireDate = fireDate
        notification.alertBody = alertBody
        notification.alertAction = alertAction
        notification.soundName = soundName
        notification.userInfo = userInfo
        if let repeatInterval = repeatInterval {
            notification.repeatInterval = repeatInterval
        }
        
        application.scheduleLocalNotification(notification)
    }
}
