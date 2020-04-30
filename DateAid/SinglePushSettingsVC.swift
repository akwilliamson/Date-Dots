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
    
    let application = UIApplication.shared
    let colorForType = ["birthday": DateType.birthday.color, "anniversary": DateType.anniversary.color, "custom": DateType.other.color]
    let timeArray = ["12:00\nAM", "1:00\nAM", "2:00\nAM", "3:00\nAM", "4:00\nAM", "5:00\nAM", "6:00\nAM", "7:00\nAM", "8:00\nAM", "9:00\nAM", "10:00\nAM", "11:00\nAM", "12:00\nPM", "1:00\nPM", "2:00\nPM", "3:00\nPM", "4:00\nPM", "5:00\nPM", "6:00\nPM", "7:00\nPM", "8:00\nPM", "9:00\nPM", "10:00\nPM", "11:00\nPM"]
    
    var previouslyScheduledNotification: UILocalNotification?
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
//
//    @IBOutlet weak var daySlider: ValueSlider!
//    @IBOutlet weak var timeSlider: ValueSlider!
    
    @IBOutlet weak var trashIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserHasEnabledLocalNotifications()
        
//        addValueChangedTargetOn([daySlider, timeSlider])
        addSingleTapGestureRecognizerOn([repeatLabel, trashIcon], forActions: ["toggleRepeat", "deletePreviousNotification"])
        
        setLabelAndSliderValues()
        setLabelAndSliderColors()
        
    }
    
    override func viewDidLayoutSubviews() {
        addLabelOnThumbForSliders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateDropInFor([dayLabel, timeLabel, repeatLabel], withDelays: [0, 0.1, 0.2])
    }
    
    func checkIfUserHasEnabledLocalNotifications() {
        let localNotificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
        application.registerUserNotificationSettings(localNotificationSettings)
    }
    
//    func addValueChangedTargetOn(_ sliders: [ValueSlider]) {
//        sliders.forEach { $0.addTarget(self, action: #selector(SinglePushSettingsVC.valueChanged(_:)), for: .valueChanged) }
//    }
    
    func addSingleTapGestureRecognizerOn(_ views: [UIView], forActions: [String]) {
        for (index, view) in views.enumerated() {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(forActions[index]))
            gestureRecognizer.numberOfTapsRequired = 1
            view.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    func setLabelAndSliderValues() {
        let allLocalNotifications = application.scheduledLocalNotifications
        
        allLocalNotifications?.forEach({
            if $0.userInfo!["date"] as? String == String(describing: dateObject.objectID.uriRepresentation()) { // There was a scheduled notification for incoming date so,
                setLabelAndSliderValues(viaNotification: $0)
                previouslyScheduledNotification = $0
            }
        })
        if previouslyScheduledNotification == nil { // There were no matching scheduled local notification, so
            setLabelAndSliderValues(viaNotification: nil)
            trashIcon.image = UIImage(named: "reminder-off.png")?.withRenderingMode(.alwaysTemplate)
            trashIcon.tintColor = dateObject.color
        }
    }
    
    func setLabelAndSliderValues(viaNotification notification: UILocalNotification?) {
        if let notification = notification {
            let notificationDaysPrior = Float(notification.userInfo!["daysPrior"] as! String)!
            let notificationHourOfDay = Float(notification.userInfo!["hoursAfter"] as! String)!
            setLabelValues(forDaysPrior: notificationDaysPrior, at: notificationHourOfDay)
            setSliderValues(forDaysPrior: notificationDaysPrior, at: notificationHourOfDay)
            repeatLabel.text = notification.repeatInterval == .year ? "Yearly" : "Once"
        } else {
            setLabelValues(forDaysPrior: 0, at: 0)
            setSliderValues(forDaysPrior: 0, at: 0)
            print((UserDefaults.standard.object(forKey: "alertYearly") as! Bool))
            if UserDefaults.standard.object(forKey: "alertYearly") as? Bool == false {
                repeatLabel.text = "Once"
            } else {
                repeatLabel.text = "Yearly"
            }
        }
    }
    
    func setLabelValues(forDaysPrior daysPrior: Float, at hourOfDay: Float) {
        dayLabel.text = setDayLabelString(forDaysPrior: daysPrior)
        timeLabel.text = setTimeLabelString(forHourOfDay: hourOfDay)
    }
    
    func setSliderValues(forDaysPrior daysPrior: Float, at hourOfDay: Float) {
//        daySlider.setValues(max: 21, value: daysPrior)
//        timeSlider.setValues(max: 23, value: hourOfDay)
    }
    
    func setDayLabelString(forDaysPrior: Float) -> String {
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
//            [daySlider, timeSlider].forEach() { $0!.setColorTo(color) }
            trashIcon.tintColor = color
        }
    }
    
    func setAlertGreeting(forHourOfDay hourOfDay: Float) -> String {
        var alertPrefix = "Good "
        if Int(hourOfDay) < 12 {
            alertPrefix.append("morning. ")
        } else if Int(hourOfDay) < 18 {
            alertPrefix.append(" afternoon. ")
        } else {
            alertPrefix.append("evening. ")
        }
        return alertPrefix
    }
    
    func setAlertSuffix(forDateObject dateObject: Date) -> String {
        switch dateObject.type! {
        case "birthday":
            return "It's \(dateObject.name!)'s birthday "
        case "anniversary":
            return "It's \(dateObject.name!)'s anniversary "
        default:
            return "\(dateObject.name!) is in "
        }
    }
    
    func setAlertMessage(forCountdown daysBefore: Float) -> String {
        var alertSuffix = setAlertSuffix(forDateObject: dateObject!)
        if daysBefore == 0 {
            alertSuffix.append("today")
        } else if daysBefore == 1 {
            alertSuffix.append("in 1 day")
        } else {
            alertSuffix.append("\(Int(daysBefore)) days")
        }
        return alertSuffix
    }
    
    func animateDropInFor(_ labels: [UILabel], withDelays delays: [TimeInterval]) {
        for (index, label) in labels.enumerated() {
            label.center.y = -50
            UIView.animate(withDuration: 1, delay: delays[index], usingSpringWithDamping: 0.6, initialSpringVelocity: 8, options: [], animations: { () -> Void in
                label.center.y = 84
                }, completion: nil)
        }
    }
    
    
    func addLabelOnThumbForSliders() {
//        daySlider.addLabelOnThumb(withText: "D")
//        timeSlider.addLabelOnThumb(withText: "T")
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
        _ = self.navigationController?.popViewController(animated: true)
    }
    
//    func setAlertBody() -> String {
//        let greeting = setAlertGreeting(forHourOfDay: timeSlider.value)
//        let message = setAlertMessage(forCountdown: daySlider.value)
//        return greeting + message
//    }
    
//    func secondsBeforeForDaysBefore() -> Double {
//        return Double(-60 * 60 * 24 * daySlider.integerValue())
//    }
    
    func secondsForHourOfDay() -> Double {
//        return Double(60 * 60 * timeSlider.integerValue())
        return 0
    }
    
    func setFireDate() -> Foundation.Date {
//        let inSeconds = secondsBeforeForDaysBefore() + secondsForHourOfDay()
//        let fireMonthAndDay = dateObject.date?.addingTimeInterval(inSeconds)
//        return fireMonthAndDay!.nextOccurence
        return Foundation.Date()
    }
    
    @IBAction func createNotification(_ sender: AnyObject) {
        deletePreviousNotification()
        
        let notification = UILocalNotification()
        let fireDate = setFireDate()
//        let alertBody = setAlertBody()
        let alertAction = "Dismiss"
        let soundName = UILocalNotificationDefaultSoundName
//        let userInfo = ["date": String(describing: dateObject.objectID.uriRepresentation()), "daysPrior": String(daySlider.integerValue()), "hoursAfter": String(timeSlider.integerValue())]
        let repeatInterval: NSCalendar.Unit? = repeatLabel.text == "Yearly" ? .year : nil

        notification.fireDate = fireDate
//        notification.alertBody = alertBody
        notification.alertAction = alertAction
        notification.soundName = soundName
//        notification.userInfo = userInfo
        if let repeatInterval = repeatInterval {
            notification.repeatInterval = repeatInterval
        }
        application.scheduleLocalNotification(notification)
    }
}
